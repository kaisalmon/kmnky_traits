local jack_of_trades = class()
local log = radiant.log.create_logger('kai')
function jack_of_trades:initialize()
   self._sv._entity = nil
   self._sv._uri = nil
end

function jack_of_trades:create(entity, uri)
   self._sv._entity = entity
   self._sv._uri = uri
   self._add_glasses = true
end

function jack_of_trades:post_activate()
   self._job_changed_listener = radiant.events.listen(self._sv._entity, 'stonehearth:job_changed', self, self._adjust_buffs)  
   self._level_up_listener = radiant.events.listen(self._sv._entity, 'stonehearth:level_up', self, self._adjust_buffs)  
end

function jack_of_trades:destroy()
   if self._job_changed_listener then
      self._job_changed_listener:destroy()
      self._job_changed_listener = nil
      self._level_up_listener:destroy()
      self._level_up_listener = nil
   end
end



function jack_of_trades:_adjust_buffs()
   local job = self._sv._entity:get_component("stonehearth:job")
   local lv = job._sv.curr_job_controller._sv.last_gained_lv
   if lv < 3 then
      radiant.entities.add_buff(self._sv._entity, 'kmnky_traits:buffs:beginners_luck')
      radiant.entities.remove_buff(self._sv._entity, 'kmnky_traits:buffs:beginners_luck_run_dry')
   else
      radiant.entities.add_buff(self._sv._entity, 'kmnky_traits:buffs:beginners_luck_run_dry')
      radiant.entities.remove_buff(self._sv._entity, 'kmnky_traits:buffs:beginners_luck')
   end
end




return jack_of_trades
