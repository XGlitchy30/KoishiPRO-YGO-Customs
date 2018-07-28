--Eradicazione Gusciosigillo
--=£lG*
function c19800018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19800018,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19800018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c19800018.condition)
	e1:SetTarget(c19800018.target)
	e1:SetOperation(c19800018.activate)
	c:RegisterEffect(e1)
end
--filters
function c19800018.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1982) and c:IsType(TYPE_MONSTER)
end
function c19800018.checkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
--Activate
function c19800018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c19800018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c19800018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19800018.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19800018.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c19800018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetBaseAttack()
		if atk<0 then atk=0 end
		--atk boost
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		--effect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_DAMAGE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c19800018.drycon)
		e2:SetOperation(c19800018.dryop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--return to hand
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetOperation(c19800018.thop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c19800018.drycon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and ep~=tp and r==REASON_BATTLE and (Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc)
		and Duel.IsExistingMatchingCard(c19800018.checkfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c19800018.dryop(e)
	local tc=e:GetLabelObject()
	local tp=tc:GetControler()
	if not Duel.IsExistingMatchingCard(c19800018.checkfilter,tp,0,LOCATION_MZONE,1,nil) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(19800018,1)) then
		local g=Duel.SelectMatchingCard(tp,c19800018.checkfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c19800018.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
		