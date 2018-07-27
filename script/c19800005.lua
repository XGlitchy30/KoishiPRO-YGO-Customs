--Gusciosigillo - Pellegrino
--=£1G*
function c19800005.initial_effect(c)
	--limit
	c:EnableReviveLimit()
	local lim=Effect.CreateEffect(c)
	lim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	lim:SetType(EFFECT_TYPE_SINGLE)
	lim:SetCode(EFFECT_SPSUMMON_CONDITION)
	lim:SetValue(c19800005.splimit)
	c:RegisterEffect(lim)
	--sleeping effect
	local se1=Effect.CreateEffect(c)
	se1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	se1:SetCode(EVENT_SPSUMMON_SUCCESS)
	se1:SetCondition(c19800005.condition0)
	se1:SetTarget(c19800005.target0)
	se1:SetOperation(c19800005.operation0)
	c:RegisterEffect(se1)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c19800005.prottg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_SINGLE)
	e1x:SetCode(EFFECT_IMMUNE_EFFECT)
	e1x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1x:SetRange(LOCATION_MZONE)
	e1x:SetValue(c19800005.efilter)
	c:RegisterEffect(e1x)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19800005.spsumlimit)
	c:RegisterEffect(e2)
	--atk boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c19800005.atkcon)
	e3:SetValue(900)
	c:RegisterEffect(e3)
	--reset flag effect
	local res=Effect.CreateEffect(c)
	res:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	res:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	res:SetCode(EVENT_LEAVE_FIELD)
	res:SetOperation(c19800005.reset_check)
	c:RegisterEffect(res)
end
--filters
function c19800005.ecount(c)
	return c:IsSetCard(0x1982) and c:IsFaceup()
end
function c19800005.atkfilter(c)
	return c:IsFaceup() and c:IsCode(19800004)
end
function c19800005.checkfilter2(c)
	return c:GetFlagEffect(19800005)>0
end
--limit
function c19800005.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0x1982)
end
--sleeping effect
function c19800005.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800004)>0
end
function c19800005.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c19800005.operation0(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsAttribute(ATTRIBUTE_DARK) then
			tc:RegisterFlagEffect(19800005,RESET_EVENT+EVENT_CUSTOM+19800012,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE,1)
		end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local op=Duel.GetOperatedGroup():GetFirst()
		if op:GetFlagEffect(19800005)>0 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
			if g:GetCount()==0 then return end
			if Duel.SelectYesNo(tp,aux.Stringid(19800005,0)) then
				Duel.BreakEffect()
				local sg=g:RandomSelect(1-tp,1)
				Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
			end
		end
	end
	--reset flag effect
	local reset=Duel.GetMatchingGroup(c19800005.checkfilter2,tp,0x10b,0x10b,nil)
	for res in aux.Next(reset) do
		res:ResetFlagEffect(19800005)
	end
end
--protection
function c19800005.prottg(e,c)
	return c:IsSetCard(0x1982)
end
function c19800005.efilter(e,re)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c19800005.ecount,c:GetControler(),LOCATION_MZONE,0,c)
	local total=0
	for i in aux.Next(g) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<total and not re:GetHandler():IsSetCard(0x1982)
end
--splimit
function c19800005.spsumlimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x1982)
end
--atk boost
function c19800005.atkcon(e)
	return Duel.IsExistingMatchingCard(c19800005.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
--reset
function c19800005.reset_check(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(19800004)>0 then
		c:ResetFlagEffect(19800004)
	end
end