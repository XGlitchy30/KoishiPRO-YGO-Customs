--Teletrasporto Gusciosigillo
--=£1G*
function c19800024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c19800024.target)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,19800024)
	e2:SetTarget(c19800024.movetg)
	e2:SetOperation(c19800024.moveop)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c19800024.attcon)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c19800024.attop)
	c:RegisterEffect(e3)
end
--filters
function c19800024.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800024.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982)
end
function c19800024.movefilter(c)
	return c:GetSequence()>=5
end
function c19800024.setfilter(c,cl)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and cl:IsContains(c)
end
function c19800024.attfilter(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==1-tp
end
--Activate
function c19800024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19800024.atkfilter(chkc) end
	if chk==0 then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE then
			return Duel.IsExistingTarget(c19800024.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
		return true
	end
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
	or (Duel.IsExistingTarget(c19800024.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(c19800024.cfilter,tp,LOCATION_MZONE,0,1,nil)) then
		if Duel.SelectYesNo(tp,aux.Stringid(19800024,0)) then
			e:SetCategory(CATEGORY_ATKCHANGE)
			e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c19800024.activate)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			Duel.SelectTarget(tp,c19800024.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		else
			e:SetCategory(0)
			e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e:SetOperation(nil)
		end
	end
end
function c19800024.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
--move
function c19800024.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19800024.movefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19800024.movefilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37480144,0))
	Duel.SelectTarget(tp,c19800024.movefilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c19800024.moveop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local prev=tc:GetSequence()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	if prev~=tc:GetSequence() then
		local column=tc:GetColumnGroup()
		local g=Duel.GetMatchingGroup(c19800024.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,column)
		if g:GetCount()<=0 then return end
		for i in aux.Next(g) do
			Duel.ChangePosition(i,POS_FACEDOWN)
			Duel.RaiseEvent(i,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
--change attribute
function c19800024.attcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19800024.attfilter,1,nil,tp)
end
function c19800024.attop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end