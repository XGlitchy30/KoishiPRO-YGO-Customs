--Gusciosigillo - Comandante
--=£lG*
function c19800011.initial_effect(c)
	--limit
	c:EnableReviveLimit()
	local lim=Effect.CreateEffect(c)
	lim:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	lim:SetType(EFFECT_TYPE_SINGLE)
	lim:SetCode(EFFECT_SPSUMMON_CONDITION)
	lim:SetValue(c19800011.splimit)
	c:RegisterEffect(lim)
	--sleeping effect
	local se1=Effect.CreateEffect(c)
	se1:SetCategory(CATEGORY_TODECK)
	se1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	se1:SetCode(EVENT_SPSUMMON_SUCCESS)
	se1:SetCondition(c19800011.condition0)
	se1:SetTarget(c19800011.target0)
	se1:SetOperation(c19800011.operation0)
	c:RegisterEffect(se1)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c19800011.prottg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_SINGLE)
	e1x:SetCode(EFFECT_IMMUNE_EFFECT)
	e1x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1x:SetRange(LOCATION_MZONE)
	e1x:SetValue(c19800011.efilter)
	c:RegisterEffect(e1x)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c19800011.spsumlimit)
	c:RegisterEffect(e2)
	--atk boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c19800011.atkcon)
	e3:SetValue(900)
	c:RegisterEffect(e3)
	--reset flag effect
	local res=Effect.CreateEffect(c)
	res:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	res:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	res:SetCode(EVENT_LEAVE_FIELD)
	res:SetOperation(c19800011.reset_check)
	c:RegisterEffect(res)
end
--filters
function c19800011.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c19800011.checkfilter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800011.ecount(c)
	return c:IsSetCard(0x1982) and c:IsFaceup()
end
function c19800011.atkfilter(c)
	return c:IsFaceup() and c:IsCode(19800010)
end
function c19800011.checkfilter2(c)
	return c:GetFlagEffect(19800011)>0
end
--limit
function c19800011.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0x1982)
end
--sleeping effect
function c19800011.condition0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(19800010)>0
end
function c19800011.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_MONSTER) and chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c19800011.operation0(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsAttribute(ATTRIBUTE_DARK) then
			tc:RegisterFlagEffect(19800011,RESET_EVENT+EVENT_CUSTOM+19800012,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE,1)
		end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		local op=Duel.GetOperatedGroup():GetFirst()
		if op:GetFlagEffect(19800011)>0 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
			if g:GetCount()==0 then return end
			if Duel.SelectYesNo(tp,aux.Stringid(19800011,0)) then
				Duel.BreakEffect()
				local sg=g:RandomSelect(1-tp,1)
				if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
					Duel.ShuffleDeck(1-tp)
					Duel.Draw(1-tp,1,REASON_EFFECT)
				end
			end
		end
	end
	--reset flag effect
	local reset=Duel.GetMatchingGroup(c19800011.checkfilter2,tp,0x10b,0x10b,nil)
	for res in aux.Next(reset) do
		res:ResetFlagEffect(19800011)
	end
end
--protection
function c19800011.prottg(e,c)
	return c:IsSetCard(0x1982)
end
function c19800011.efilter(e,re)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c19800011.ecount,c:GetControler(),LOCATION_MZONE,0,c)
	local total=0
	for i in aux.Next(g) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<total and not re:GetHandler():IsSetCard(0x1982)
end
--splimit
function c19800011.spsumlimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x1982)
end
--atk boost
function c19800011.atkcon(e)
	return Duel.IsExistingMatchingCard(c19800011.atkfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
--reset
function c19800011.reset_check(e)
	local c=e:GetHandler()
	if c:GetFlagEffect(19800010)>0 then
		c:ResetFlagEffect(19800010)
	end
end