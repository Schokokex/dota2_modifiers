modifier_lebowsky = class({})

function modifier_lebowsky:GetTexture() return "alchemist_chemical_rage" end

function modifier_lebowsky:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_lebowsky:OnCreated(event)
	self:OnRefresh(event)
	self.AttackCounter=0
	print("leb creat",self:GetParent():GetName())
end

function modifier_lebowsky:OnRefresh(event)
	if IsClient() then return end
	local hero=self:GetCaster()
	print("leb refresh",self:GetParent():GetName())
	if event.anger==1 and self.anger~=1 then EmitSoundOn("taken",hero) end
	self.gold=event.gold
	self.anger=event.anger
	self:SetStackCount(event.anger)
end

function modifier_lebowsky:OnAttackLanded(event)
	-- for k,v in pairs(event) do print("attack",k,v) end
	local hero=self:GetCaster()
	local rosh=self:GetParent()
	local target=event.target
	local attacker=event.attacker
	-- if !(TargetIsMainTarget and (attacker:ForceAttack or attacker:Hired)) then return end
	if not(		target==rosh:GetForceAttackTarget()
			and	(attacker:GetForceAttackTarget()==target or attacker:FindModifierByName("modifier_get_hired"))
	) then return end
	self:yell(attacker)
	if self.anger==nil then return end
	if self.anger>=3 then
		sellRandomItem(hero)
	end
	if RollPercentage(15) and hero:GetHealth()<event.damage*1.5 and event.damage<hero:GetHealth() then
		EmitSoundOn("hitme",hero)
	end
end

function modifier_lebowsky:yell(attacker)
	if self.gold>=1000 then
		if self.AttackCounter%50==0 then
			EmitSoundOn("stewie",attacker) end
	elseif self.AttackCounter%20==0 then
		EmitSoundOn("lebowsky",attacker)
	end
	self.AttackCounter=self.AttackCounter+1
end

require("evil_utils")