
local Pacifist = class()

local log = radiant.log.create_logger('kai')
function Pacifist:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function Pacifist:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
end

function Pacifist:post_activate()
   local json = radiant.resources.load_json(self._sv._uri)
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", "flower")

    local population = stonehearth.population:get_population(self._sv._entity:get_player_id())
    self.pop_listener = radiant.events.listen_once(population, 'stonehearth:population:citizen_count_changed', function()
      if not self._sv._entity:get_component('stonehearth:unit_info')._sv._made_pacifist then
         local all_jobs = stonehearth.player:get_jobs(self._sv._entity:get_player_id())
         local allowed_jobs = {}
         for job_uri, _ in pairs(all_jobs) do
            allowed_jobs[job_uri] =  not stonehearth.job:get_job_info(self._sv._entity:get_player_id(), job_uri):is_combat_job()
         end
         self._sv._entity:get_component('stonehearth:job')._sv.allowed_jobs = allowed_jobs
         self._sv._entity:get_component('stonehearth:unit_info')._sv._made_pacifist = true

         -- PROMOTE THE HEARTHLING TO IT'S OWN JOB AGAIN, This is a hack to fix a rendering bug in the promotion tree
        local options = {}
        options.dont_drop_talisman = true
        options.skip_visual_effects = true
        local current_job_uri = self._sv._entity:get_component('stonehearth:job')._sv.job_uri
        self._sv._entity:get_component('stonehearth:job'):promote_to(current_job_uri, options)

      end
   end)
      
end

function Pacifist:destroy()
   local customization_component = self._sv._entity:get_component('stonehearth:customization')
   customization_component:change_customization("eyebrows", nil)
    self.pop_listener:destroy()
end

if GameCreationService and not GameCreationService.kmnky_traits_injection then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
   GameCreationService.kmnky_traits_injection = true
end

return Pacifist
