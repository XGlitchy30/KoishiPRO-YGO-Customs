--Gusciosigillo - Faro
--=£lG*
function c19800014.initial_effect(c)
	--limit
	c:EnableReviveLimit()
	local lim=Effect.CreateEffect(c)
	lim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	lim:SetType(EFFECT_TYPE_SINGLE)
	lim:SetCode(EFFECT_SPSUMMON_CONDITION)
	lim:SetValue(c19800014.splimit)
	c:RegisterEffect(lim)
	--sleeping effect
	local se1=Effect.CreateEffect(c)
	se1:SetCategory(CATEGORY_TODECK)
	se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	se1:SetCode(EVENT_SPSUMMON_SUCCESS)
	se1:SetCondition(c19800014.condition0)
	se1:SetOperation(c19800014.operation0)
	c:RegisterEffect(se1)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c19800014.prottg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_SINGLE)
	e1x:SetCode(EFFECT_IMMUNE_EFFECT)
	e1x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1x:SetRange(LOCATION_MZONE)
	e1x:SetValue(c19800014.efilter)
	c:RegisterEffect(e1x)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19800014.spsumlimit)
	c:RegisterEffect(e2)
	--atk boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c19800014.atkcon)
	e3:SetValue(900)
	c:RegisterEffect(e3)
	--reset flag effect
	local res=Effect.CreateEffect(c)
	res:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	res:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	res:SetCode(EVENT_LEAVE_FIELD)
	res:SetOperation(c19800014.reset_check)
	c:RegisterEffect(res)
end
--filters
function c19800014.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19800014.checkfilter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800014.ecount(c)
	return c:IsSetCard(0x1982) and c:IsFaceup()
end
function c19800014.atkfilter(c)
	return c:IsFaceup() and c:IsCode(19800013)
end
--limit
function c19800014.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0x1982)
end
--sleeping effect
function c19800014.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800013)>0
end
function c19800014.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c19800014.multiatk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	--change base atk
	local opfield=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local check=opfield:Filter(c19800014.checkfilter,tp,0,LOCATION_MZONE,nil)
	if opfield:GetCount()>0 and check:GetCount()<=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(2800)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function c19800014.multiatk(e,c)
	return c:IsFaceup()
end
--protection
function c19800014.prottg(e,c)
	return c:IsSetCard(0x1982)
end
function c19800014.efilter(e,re)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c19800014.ecount,c:GetControler(),LOCATION_MZONE,0,c)
	local total=0
	for i in aux.Next(g) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<total and not re:GetHandler():IsSetCard(0x1982)
end
--splimit
function c19800014.spsumlimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x1982)
end
--atk boost
function c19800014.atkcon(e)
	return Duel.IsExistingMatchingCard(c19800014.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
--reset
function c19800014.reset_check(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(19800013)>0 then
		c:ResetFlagEffect(19800013)
	end
end