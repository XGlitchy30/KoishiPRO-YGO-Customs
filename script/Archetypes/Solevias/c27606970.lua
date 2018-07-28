--Altare della Solfenice
--Script by XGlitchy30
function c27606970.initial_effect(c)
	c:SetUniqueOnField(1,0,27606970)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606970+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27606970.target)
	e1:SetOperation(c27606970.activate)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c27606970.infilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21606970+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c27606970.sptg)
	e3:SetOperation(c27606970.spop)
	c:RegisterEffect(e3)
	--leave field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetCondition(c27606970.lfcon)
	e0:SetOperation(c27606970.lfield)
	c:RegisterEffect(e0)
	--lp cost
	local fix=Effect.CreateEffect(c)
	fix:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	fix:SetCode(EVENT_LEAVE_FIELD)
	fix:SetCondition(c27606970.sccon)
	fix:SetOperation(c27606970.scop)
	c:RegisterEffect(fix)
end
--filters
function c27606970.actfilter(c)
	return c:IsSetCard(0x3721) and c:IsAbleToGrave()
end
function c27606970.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x3721) or bit.band(c:GetType(),0x81)~=0x81 or c:IsPublic() or c:IsCode(27606962)
		or not c:IsCanBeSpecialSummoned(e,0,tp,true,false) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel()+1,c)
end
function c27606970.filterF(c)
	return c:IsSetCard(0x3721) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
--Activate
function c27606970.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606970.actfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c27606970.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27606970.actfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--indestructable
function c27606970.infilter(e,c)
	return c:IsSetCard(0x3721) and c:GetLevel()<=6
end
--spsummon
function c27606970.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c27606970.filterF,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c27606970.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27606970.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c27606970.filterF,tp,LOCATION_DECK,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=Duel.SelectMatchingCard(tp,c27606970.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel()+1,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			mat=mg:FilterSelect(tp,c27606970.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel()+1,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		if Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)~=0 then
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			Duel.SpecialSummonComplete()
			tc:CompleteProcedure()
			e:GetHandler():SetCardTarget(tc)
		end
	end
end
--leave field
function c27606970.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c27606970.lfield(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--lp cost
function c27606970.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c27606970.scop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
end