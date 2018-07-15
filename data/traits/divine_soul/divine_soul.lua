local DivineSoul = class()

local log = radiant.log.create_logger('kai')
function DivineSoul:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function DivineSoul:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
end

function DivineSoul:activate()
   local json = radiant.resources.load_json(self._sv._uri)
   local population = stonehearth.population:get_population(self._sv._entity:get_player_id())

   -- TODO: Make sure that this listener only gets added ONCE
   -- this means somehow adding some metadata to the hearthling


   self.pop_listener = radiant.events.listen_once(population, 'stonehearth:population:citizen_count_changed', function()
      if not self._sv._entity:get_component('stonehearth:unit_info')._sv._made_divine_soul then
         local options = {}
         options.dont_drop_talisman = true
         options.skip_visual_effects = true
         self._sv._entity:get_component('stonehearth:job'):promote_to('stonehearth:jobs:cleric', options)
         self._sv._entity:get_component('stonehearth:equipment'):unequip_item('stonehearth:weapons:tome')
         self._sv._entity:get_component('stonehearth:equipment'):equip_item('kmnky_traits:weapons:soul_staff')
         self._sv._entity:get_component('stonehearth:equipment'):equip_item('kmnky_traits:traits:soul_outfit')
         self._sv._entity:get_component('stonehearth:unit_info')._sv._made_divine_soul = true
      end
   end)
   
end

function DivineSoul:destroy()
    self.pop_listener:destroy()
end



return DivineSoul
