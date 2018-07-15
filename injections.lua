
if GameCreationService then
   local old_randomize_citizen = GameCreationService._randomize_citizen

   function GameCreationService:_randomize_citizen(citizen, pop, gender, locked_options)
      old_randomize_citizen(self, citizen, pop, gender, locked_options)
      pop:regenerate_stats(citizen, { embarking = true })
   end
end