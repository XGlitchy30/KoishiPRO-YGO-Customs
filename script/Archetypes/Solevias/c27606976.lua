--Eclisse della Solfenice
--Script by XGlitchy30
function c27606976.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606976+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27606976.target)
	e1:SetOperation(c27606976.activate)
	c:RegisterEffect(e1)
end
--filters
function c27606976.costfilter(c)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
--Activate
function c27606976.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c27606976.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27606976.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,c27606976.costfilter,1,1,REASON_EFFECT)
	Duel.BreakEffect()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end