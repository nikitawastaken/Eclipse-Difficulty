Hooks:PostHook(EventJobsTweakData, "init", "eclipse_init", function(self)
    table.delete(self.challenges, self.challenges[19]) -- no shredding christmas sidejob to avoid crashes
end)