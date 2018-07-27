--Procedura Gusciosigillo
--=£1G*
function c19800023.initial_effect(c)
	c:SetUniqueOnField(1,0,19800023)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c19800023.aclimit)
	e1:SetCondition(c19800023.actcon)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c19800023.atcon)
	e2:SetCost(c19800023.atcost)
	e2:SetTarget(c19800023.attg)
	e2:SetOperation(c19800023.atop)
	c:RegisterEffect(e2)
end
--filters
function c19800023.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1982) and c:IsControler(tp)
end
function c19800023.atfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x1982)
end
--actlimit
function c19800023.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c19800023.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c19800023.cfilter(a,tp)) or (d and c19800023.cfilter(d,tp))
end
--negate attack
function c19800023.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.IsExistingMatchingCard(c19800023.atfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c19800023.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c19800023.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) and tg:IsAbleToDeck() end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function c19800023.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack() and tc:IsAbleToDeck() then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end