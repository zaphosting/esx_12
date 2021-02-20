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

local Input = M('input')

self.Init = function()
  Input.RegisterControl(1, 74)
  Input.RegisterControl(1, 21)
  local translations = ESX.EvalFile(GetCurrentResourceName(), 'modules/voice/data/locales/' .. Config.Locale .. '.lua')['Translations']
  LoadLocale('voice', Config.Locale, translations)
  self.voice = {default = 5.0, shout = 12.0, whisper = 1.0, current = 0, level =  _U('voice:normal')}
end

self.DrawLevel = function(r,g,b,a)
	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(_U('voice:voice', self.voice.level))
	EndTextCommandDisplayText(0.175, 0.92)
end
