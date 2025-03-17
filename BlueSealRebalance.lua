local function calculate(self, card, context)
  if context.cardarea == G.hand
     and context.main_scoring
     and not context.repetition_only -- TODO: redundant?
     and #G.consumeables.cards + G.GAME.consumeable_buffer
         < G.consumeables.config.card_limit then
    if pseudorandom('blue_seal')
       >= (G.GAME.probabilities.normal * #context.scoring_hand)
          /self.config.extra then
      -- Retrigger logic has a bug that prevents a retrigger from happening if
      -- the first trigger didn't do anything.
      -- This bug exists in vanilla with Mime + Reserved Parking.
      -- To avoid this bug, if a roll fails we lie and say something happened
      -- regardless.

      -- Special case for Mime to make the behaviour slightly more intuitive
      -- (if inconsistent compared to when Mime isn't present)
      -- Ideally, this would be a generic check to see if the card would be
      -- subject to retriggering, but unfortunately `reps` is not made available
      -- in the context and recalculating it is too ugly to my sensibilities.
      if next(SMODS.find_card('j_mime')) then
        return { message = localize('k_nope_ex'),
                 colour = G.C.UI.TEXT_INACTIVE,
                 sound = 'cancel' }
      end
      return { effect = true }
    end
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
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
    return { message = localize('k_plus_planet'),
             colour = G.C.SECONDARY_SET.Planet }
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