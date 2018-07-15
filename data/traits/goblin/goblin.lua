local GoblinTrait = class()
local log = radiant.log.create_logger('kai')

function GoblinTrait:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function GoblinTrait:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
end

function GoblinTrait:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)
   self:_add_customization()
   log:error("Goblin Post Activate");
   self._melee_listener = radiant.events.listen(self._sv._entity, 'stonehearth:combat:assault', self, self._on_attack)
end

function GoblinTrait:destroy()
   self:_remove_customization()
end

function dump(o)
   local has_pairs = pcall(pairs, o)
   local has_getmetatable = getmetatable(pairs, o)
   if has_getmetatable then
      o = getmetatable(o)
   end
   if has_pairs then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function GoblinTrait:_on_attack(context)
   local attacker_id = context.attacker:get_player_id()
   if attacker_id == 'goblins' then
      radiant.entities.add_thought(self._sv._entity, 'stonehearth:thoughts:traits:hurt_by_goblin')
   end
end

function GoblinTrait:_add_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("head_hair", "goblin")
   customization_component:change_customization("skin_color", "goblin")
   customization_component:change_customization("hair_color", "red")
end

function GoblinTrait:_remove_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("head_hair", nil)
end

if GameCreationService and not GameCreationService.kmnky_traits_injection then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
   GameCreationService.kmnky_traits_injection = true
end

return GoblinTrait
