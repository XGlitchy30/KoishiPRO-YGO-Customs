--Gusciosigillo - Inizializzatore
--=£1G*
function c19800007.initial_effect(c)
	--limit
	c:EnableReviveLimit()
	local lim=Effect.CreateEffect(c)
	lim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	lim:SetType(EFFECT_TYPE_SINGLE)
	lim:SetCode(EFFECT_SPSUMMON_CONDITION)
	lim:SetValue(c19800007.splimit)
	c:RegisterEffect(lim)
	--sleeping effect
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	se1:SetCode(EVENT_SPSUMMON_SUCCESS)
	se1:SetCondition(c19800007.condition0)
	se1:SetTarget(c19800007.target0)
	se1:SetOperation(c19800007.operation0)
	c:RegisterEffect(se1)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19800007.ptcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_SINGLE)
	e1x:SetCode(EFFECT_IMMUNE_EFFECT)
	e1x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1x:SetRange(LOCATION_MZONE)
	e1x:SetValue(c19800007.efilter)
	c:RegisterEffect(e1x)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19800007.spsumlimit)
	c:RegisterEffect(e2)
	--atk boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c19800007.atkcon)
	e3:SetValue(900)
	c:RegisterEffect(e3)
	--reset flag effect
	local res=Effect.CreateEffect(c)
	res:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	res:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	res:SetCode(EVENT_LEAVE_FIELD)
	res:SetOperation(c19800007.reset_check)
	c:RegisterEffect(res)
end
--filters
function c19800007.actfilter(c)
	return c:IsSetCard(0x1982) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c19800007.checkfilter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800007.dryfilter(c,fid)
	return c:GetFlagEffectLabel(19800007)==fid
end
function c19800007.ptfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800007.atkfilter(c)
	return c:IsFaceup() and c:IsCode(19800006)
end
--limit
function c19800007.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0x1982)
end
--sleeping effect
function c19800007.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800006)>0
end
function c19800007.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c19800007.actfilter,tp,LOCATION_DECK,0,1,nil,tp) 
	end
end
function c19800007.operation0(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local opfield=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local check=opfield:Filter(c19800007.checkfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(c19800007.actfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local ct=0
	if ft==1 or (ft>1 and (opfield:GetCount()<=0 or (opfield:GetCount()>0 and check:GetCount()>0))) then
		ct=1
	elseif ft>1 and opfield:GetCount()>0 and check:GetCount()<=0 then
		ct=2
	end
	local fid=e:GetHandler():GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,1,ct,nil)
	local tg=tc:GetFirst()
	while tg do
		Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--register flag
		tg:RegisterFlagEffect(19800007,RESET_EVENT+0x1fe0000,0,1,fid)
		tg=tc:GetNext()
	end
	--self destruct
	tc:KeepAlive()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCountLimit(1)
	e0:SetLabel(fid)
	e0:SetLabelObject(tc)
	e0:SetCondition(c19800007.drycon)
	e0:SetOperation(c19800007.dryop)
	Duel.RegisterEffect(e0,tp)
end
function c19800007.drycon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c19800007.dryfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c19800007.dryop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c19800007.dryfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
--protection
function c19800007.ptcon(e)
	return Duel.IsExistingMatchingCard(c19800007.ptfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c19800007.efilter(e,re)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c19800007.ptfilter,c:GetControler(),LOCATION_MZONE,0,c)
	local total=0
	for i in aux.Next(g) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<total and not re:GetHandler():IsSetCard(0x1982)
end
--splimit
function c19800007.spsumlimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x1982)
end
--atk boost
function c19800007.atkcon(e)
	return Duel.IsExistingMatchingCard(c19800007.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
--reset
function c19800007.reset_check(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(19800006)>0 then
		c:ResetFlagEffect(19800006)
	end
end