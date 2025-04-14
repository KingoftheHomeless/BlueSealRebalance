local function calculate(self, card, context)
  if context.cardarea == G.hand
     and context.main_scoring
     and #G.consumeables.cards + G.GAME.consumeable_buffer
         < G.consumeables.config.card_limit then
    local scoring = 0
    for _, c in ipairs(context.scoring_hand) do
        if not c.debuff then
            scoring = scoring + 1
        end
    end
    if scoring == 0 then
        return nil
    end
    if pseudorandom('blue_seal')
       >= (G.GAME.probabilities.normal * scoring)
          /self.config.extra then
        -- Part of a HACK, see below
        if context.BlueSealRebalance_being_repeated then
            return { on_no_other_effect = {
                 message = localize('k_nope_ex'),
                 colour = G.C.UI.TEXT_INACTIVE,
                 sound = 'cancel' } }
        else
            return { effect = true }
        end
    end
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    local function spawn_planet()
        G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
            local _planet = nil
                    for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == G.GAME.last_hand_played then
                            _planet = v.key
                        end
                    end
            if not _planet then
            sendWarnMessage('Unable to find Planet card for played hand! '
                            .. 'Using Pluto as fallback.',
                            'BlueSealRebalance')
                _planet = 'c_pluto'
            end
            local planet = create_card(
            card_type, G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
            planet:add_to_deck()
            G.consumeables:emplace(planet)
            G.GAME.consumeable_buffer = 0
            return true
        end)}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
    end
    return { func = spawn_planet }
  end
end

SMODS.Seal:take_ownership('Blue', {
  atlas = 'centers',
  pos = { x = 6, y = 4 },
  badge_colour = G.C.BLUE,
  loc_txt = {
    name = 'Blue Seal',
    text = {
      "If {C:attention}held{} in hand, {C:green}#1# in #2#{} chance",
      "times the number of {C:attention}scoring cards{}",
      "to create the {C:planet}Planet{} card for played",
      "{C:attention}poker hand{}. {C:inactive}(Must have room)",
    },
  },
  loc_vars = function(self, info_queue)
    return { vars = { G.GAME.probabilities.normal, self.config.extra } }
  end,
  config = {
    extra = 8,
  },
  calculate = calculate,
})

local orig_get_end_of_round_effect = Card.get_end_of_round_effect
function Card:get_end_of_round_effect(context)
  -- Dirty workaround to prevent Blue seal's hard-coded vanilla effect
  local orig_seal = self.seal
  if orig_seal == 'Blue' then
    -- Placeholder instead of nil in case something would check
    -- that a seal is present
     self.seal = 'Totally not a Blue Seal you guys'
  end
  local ret = orig_get_end_of_round_effect(self, context)
  -- Explicit check for placeholder just in case something has changed the seal
  if self.seal == 'Totally not a Blue Seal you guys' then
    self.seal = orig_seal
  end
  return ret
end

-- HACK:
-- Retrigger logic has a bug that prevents a retrigger from happening if
-- the first trigger didn't do anything.
-- This bug exists in vanilla with Mime + Reserved Parking.
-- The below is a collection of horrible, HORRIBLE hackery to not only avoid that bug
-- (which would be as easy as returning { effect = true} from calculate()), BUT also indicate *what* card
-- is *being acted upon* by any "Again!" message, if nothing else would.
local orig_trigger_effects = SMODS.trigger_effects
SMODS.trigger_effects = function(effects, card)
    local ret = orig_trigger_effects(effects, card)
    if not effects.calculated then
        local on_no_other_effect = nil
        local on_no_other_effect_key = nil
        for i, effect_table in ipairs(effects) do
            for key, effect in pairs(effect_table) do
                if type(effect) == 'table' then
                    on_no_other_effect = effect.on_no_other_effect
                    on_no_other_effect_key = key
                    if on_no_other_effect then
                        break
                    end
                end
            end
        end
        if on_no_other_effect then
            local calc = SMODS.calculate_effect(on_no_other_effect, card, on_no_other_effect_key == 'edition')
            if calc then effects.calculated = true end
        end
    end
    return ret
end

local orig_calculate_repetitions = SMODS.calculate_repetitions
SMODS.calculate_repetitions = function(card, context, reps)
    ret = orig_calculate_repetitions(card, context, reps)
    context.BlueSealRebalance_being_repeated = #reps > 1
    if context.cardarea == G.hand
       and card.seal == 'Blue'
       and #G.consumeables.cards + G.GAME.consumeable_buffer
           < G.consumeables.config.card_limit
       and #reps > 1 then
        candidate = nil
        for i, effect_table in ipairs(context.card_effects) do
            for key, effect in pairs(effect_table) do
                if type(effect) == 'table' then
                    for effkey, effval in pairs(effect) do
                        if effkey == "effect" and effval == true then
                            candidate = true
                        elseif effkey ~= "smods" and effkey ~= "card" and effkey ~= nil and effval ~= nil then
                            candidate = false
                            break
                        end
                    end
                end
                if candidate == false then
                    break
                end
            end
            if candidate == false then
                break
            end
        end

        if candidate then
             card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.UI.TEXT_INACTIVE, sound = 'cancel'})
        end
    end
    return ret
end