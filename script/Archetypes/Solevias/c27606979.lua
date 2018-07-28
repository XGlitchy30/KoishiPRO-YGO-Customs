--Luce della Solfenice
--Script by XGlitchy30
function c27606979.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27606979+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c27606979.fixcost)
	e1:SetTarget(c27606979.target)
	e1:SetOperation(c27606979.activate)
	c:RegisterEffect(e1)
end
--filters
function c27606979.filter(c,e,tp,m,ft)
	if not (c:IsCode(27606980,27606981) or c:IsAttribute(ATTRIBUTE_LIGHT)) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local alt=Duel.GetMatchingGroup(c27606979.alt_filter,tp,LOCATION_DECK,0,1,c,c)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c) or (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and alt:GetCount()>0)
	else
		return mg:IsExists(c27606979.filterF,1,nil,tp,mg,c)
	end
end
function c27606979.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c27606979.alt_filter(c,rlev)
	return c:IsSetCard(0x3721) and c:GetLevel()>=rlev:GetLevel() and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK)
end
function c27606979.alt_filter_generic(c)
	return c:IsSetCard(0x3721) and c:GetLevel()>0 and c:IsAbleToGrave() and c:IsLocation(LOCATION_DECK)
end
--Activate
function c27606979.fixcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
	end
end
function c27606979.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c27606979.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c27606979.activate(e,tp,eg,ep,ev,re,r,rp)
	local rt=Group.CreateGroup()
	local mgx=Duel.GetRitualMaterial(tp)
	local ftx=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rtcheck=Duel.GetMatchingGroup(c27606979.filter,tp,LOCATION_HAND,0,nil,e,tp,mgx,ftx)
	for ix in aux.Next(rtcheck) do
		if Duel.IsExistingMatchingCard(c27606979.alt_filter,tp,LOCATION_DECK,0,1,ix,ix) then
			rt:AddCard(ix)
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE>0) and rt:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(27606979,0)) then
			local mg1=Duel.GetMatchingGroup(c27606979.alt_filter_generic,tp,LOCATION_DECK,0,nil)
			local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg1=Duel.SelectMatchingCard(tp,c27606979.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,ft1)
			local tc1=tg1:GetFirst()
			if tc1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c27606979.alt_filter,tp,LOCATION_DECK,0,1,1,nil,tc1)
				if g:GetCount()>0 then
					tc1:SetMaterial(g)
					Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc1:CompleteProcedure()
					tc1:RegisterFlagEffect(27606979,RESET_EVENT+0x1fe0000,0,1)
					e:SetLabel(100)
					--EP effect
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e1:SetLabelObject(tc1)
					e1:SetCondition(c27606979.EPcon)
					e1:SetOperation(c27606979.EPop)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
	if e:GetLabel()==100 then return end
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c27606979.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c27606979.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:RegisterFlagEffect(27606979,RESET_EVENT+0x1fe0000,0,1)
		tc:CompleteProcedure()
		--EP effect
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c27606979.EPcon)
		e1:SetOperation(c27606979.EPop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
--EP parameters
function c27606979.EPcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(27606979)~=0 and not tc:IsSetCard(0x3721) then
		return true
	else
		e:Reset()
		return false
	end
end
function c27606979.EPop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end