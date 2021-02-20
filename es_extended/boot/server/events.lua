-- Copyright (c) Jérémie N'gadi
--
-- All rights reserved.
--
-- Even if 'All rights reserved' is very clear :
--
--   You shall not use any piece of this software in a commercial product / service
--   You shall not resell this software
--   You shall not provide any facility to install this particular software in a commercial product / service
--   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
--   This copyright should appear in every part of the project code

local self = ESX.Modules['boot']

-- Need a bit of core modules here
self.LoadModule('events', true)

on('esx:migrations:done', function()

	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			ESX.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	end)

	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)

    for i=1, #jobs, 1 do

      local row = jobs[i]

			ESX.Jobs[row.name]        = row
      ESX.Jobs[row.name].grades = {}

		end

		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)

      for i=1, #jobGrades, 1 do

        local row = jobGrades[i]

				if ESX.Jobs[row.job_name] then
					ESX.Jobs[row.job_name].grades[tostring(row.grade)] = row
				else
					print(('[^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(row.job_name))
        end

			end

			for k,v in pairs(ESX.Jobs) do
				if table.sizeOf(v.grades) == 0 then
					ESX.Jobs[v.name] = nil
					print(('[^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v.name))
				end
      end

      ESX.Ready = true

      emit('esx:ready')

      print('^2server ready^7')

		end)
	end)

end)
