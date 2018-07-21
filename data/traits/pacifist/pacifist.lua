
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

function Pacifist:activate()
   local json = radiant.resources.load_json(self._sv._uri)
   local population = stonehearth.population:get_population(self._sv._entity:get_player_id())

   local jobs = stonehearth.player:get_jobs(self._sv._entity:get_player_id())
 --  jobs["stonehearth:jobs:knight"] = false
 --  jobs["stonehearth:jobs:archer"] = false
 --  jobs["stonehearth:jobs:footman"] = false
--   jobs["stonehearth:jobs:cleric"] = false

   for job_uri,v in pairs(jobs) do
      jobs[job_uri] = not stonehearth.job:get_job_info(radiant.entities.get_player_id(self._sv._entity), job_uri):is_combat_job()
   end
   self._sv._entity:get_component('stonehearth:job'):set_allowed_jobs(jobs) -- Set alloweds jobs to "all", but our injection will ensure that the knight is filtered out! (No shields allowed!)

   
end

function Pacifist:destroy()
   self.pop_listener:destroy()
end


return Pacifist
