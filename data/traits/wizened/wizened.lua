local foureyes = class()

local log = radiant.log.create_logger('kai')
function foureyes:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function foureyes:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
   self._add_glasses = true
end

function foureyes:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)

   -- Add glasses asset on creation
   local customization = json.data.customization
   self._subcategory = customization.subcategory
   self._style = customization.style
   if self._add_glasses then
      self:_add_glasses_customization()
   end
end

function foureyes:destroy()

   self:_remove_glasses_customization()

end


function foureyes:_add_glasses_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization(self._subcategory, self._style)
   customization_component:change_customization("hair_color", "platinum")
end

function foureyes:_remove_glasses_customization()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization(self._subcategory, nil)
end

if GameCreationService and not GameCreationService.kmnky_traits_injection then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
   GameCreationService.kmnky_traits_injection = true
end

return foureyes
