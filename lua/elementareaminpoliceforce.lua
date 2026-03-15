-- Vanilla reinforce points now have a force value of at least 2
-- Most have the very weird force value of 1, causing the point to never repopulate until wiped out
-- Would presume level designers thought the force value was the number of groups to deploy
Hooks:PostHook(ElementAreaMinPoliceForce, "init", "eclipse_init", function(self)
	if self._values.amount then
		self._values.amount = math.max(self._values.amount, 2)
	end
end)
