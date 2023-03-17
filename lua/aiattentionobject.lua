-- Remove attention objects that are considered stealth only when the game goes loud
-- Simply exclude any attention setting that doesnt have a team relation or violent reaction
local add_attention_original = AIAttentionObject.add_attention
function AIAttentionObject:add_attention(settings, ...)
	settings.stealth_only = not settings.relation or settings.reaction and settings.reaction < AIAttentionObject.REACT_AIM

	if settings.stealth_only then
		if managers.groupai:state():enemy_weapons_hot() then
			return
		end

		if not self._enemy_weapons_hot_listen_id then
			self._enemy_weapons_hot_listen_id = "AIAttentionObject_enemy_weapons_hot" .. tostring(self._unit:key())
			managers.groupai:state():add_listener(self._enemy_weapons_hot_listen_id, { "enemy_weapons_hot" }, callback(self, self, "clbk_enemy_weapons_hot"))
		end
	end

	return add_attention_original(self, settings, ...)
end

function AIAttentionObject:clbk_enemy_weapons_hot()
	self._enemy_weapons_hot_listen_id = nil

	if not self._attention_data then
		return
	end

	for id, settings in pairs(self._attention_data) do
		if settings.stealth_only then
			self._attention_data[id] = nil
		end
	end

	if not next(self._attention_data) then
		managers.groupai:state():unregister_AI_attention_object((self._parent_unit or self._unit):key())
		self._attention_data = nil
	end

	self:_call_listeners()
end

Hooks:PreHook(AIAttentionObject, "destroy", "sh_destroy", function (self)
	if self._enemy_weapons_hot_listen_id then
		managers.groupai:state():remove_listener(self._enemy_weapons_hot_listen_id)
		self._enemy_weapons_hot_listen_id = nil
	end
end)