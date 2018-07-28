--Incarnazione della Solfenice
--Script by XGlitchy30
function c27606985.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3721),6,2)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,27606985)
	--stats down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c27606985.con)
	e1:SetTarget(c27606985.tg)
	e1:SetValue(-3000)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1x)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,27606985)
	e2:SetCost(c27606985.tgcost)
	e2:SetTarget(c27606985.tgtg)
	e2:SetOperation(c27606985.tgop)
	c:RegisterEffect(e2)
	--gain LP
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c27606985.sccon)
	e3:SetTarget(c27606985.sctg)
	e3:SetOperation(c27606985.scop)
	c:RegisterEffect(e3)
end
--filters
function c27606985.rmfilter(c,tp,e)
	return c:IsSetCard(0x3721) and c:IsType(TYPE_MONSTER) and c:GetLevel()<=6 and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c27606985.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetCode(),e,tp)
end
function c27606985.spfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
--stats down
function c27606985.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandler():GetControler())<Duel.GetLP(1-e:GetHandler():GetControler())
end
function c27606985.tg(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
--special summon
function c27606985.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27606985.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27606985.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp,e)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c27606985.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606985.rmfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp,e)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			local code=Duel.GetOperatedGroup():GetFirst():GetCode()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sp=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606985.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,Duel.GetOperatedGroup():GetFirst(),code,e,tp)
			if sp:GetCount()>0 then
				Duel.SpecialSummon(sp,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
--gain lp
function c27606985.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c27606985.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c27606985.scop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end