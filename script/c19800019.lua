--Errore Gusciosigillo
--=£1G*
function c19800019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19800019,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabelObject(e2)
	e1:SetTarget(c19800019.sptg)
	e1:SetOperation(c19800019.spop)
	c:RegisterEffect(e1)
end
--filters
function c19800019.cfilter(c,tp,e)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x1982)
		and Duel.IsExistingMatchingCard(c19800019.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode()+1)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and ((code>=19800004 and code<=19800010) or code==19800013)
end
function c19800019.spfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP) and c:IsType(TYPE_LINK) and c:GetCode()==code
end
function c19800019.checksp(c,card)
	return c:IsFaceup() and c==card
end
function c19800019.pilgrim(c)
	return c:IsSetCard(0x1982) and c:IsAbleToHand() and not c:IsCode(19800019)
end
function c19800019.initializer(c,e,tp)
	return c:IsSetCard(0x1982) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c19800019.analyzer(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x1982)
end
function c19800019.commander(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
--Activate
function c19800019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19800019.cfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,tp,e) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19800019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19800019.cfilter),tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,tp,e)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
				local code=Duel.GetOperatedGroup():GetFirst():GetCode()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sp=Duel.SelectMatchingCard(tp,c19800019.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code+1)
				local tc=sp:GetFirst()
				e:SetLabelObject(tc)
				if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_ATTACK)
					e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e3,true)
					Duel.SpecialSummonComplete()
					--effect
					local ee2=Effect.CreateEffect(c)
					ee2:SetDescription(aux.Stringid(19800019,1))
					ee2:SetType(EFFECT_TYPE_IGNITION)
					ee2:SetRange(LOCATION_GRAVE)
					ee2:SetLabelObject(e:GetLabelObject())
					ee2:SetCondition(c19800019.condition)
					ee2:SetCost(aux.bfgcost)
					ee2:SetTarget(c19800019.target)
					ee2:SetOperation(c19800019.operation)
					ee2:SetReset(RESET_REMOVE+RESET_TOHAND+RESET_TOFIELD+RESET_TODECK+RESET_TURN_SET)
					c:RegisterEffect(ee2)
				end
			end
		end
	end
end
--effect
function c19800019.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) --and Duel.IsExistingMatchingCard(c19800019.checksp,tp,LOCATION_MZONE,0,1,e:GetLabelObject())
end
function c19800019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=Duel.GetMatchingGroup(c19800019.checksp,tp,LOCATION_MZONE,0,nil,e:GetLabelObject()):GetFirst():GetCode()
	if chk==0 then
		if code==19800005 then
			return Duel.IsExistingMatchingCard(c19800019.pilgrim,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
		elseif code==19800007 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c19800019.initializer,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		elseif code==19800009 then
			return Duel.IsExistingTarget(c19800019.analyzer,tp,LOCATION_SZONE,0,1,nil)
		elseif code==19800011 then
			return Duel.IsExistingMatchingCard(c19800019.commander,tp,LOCATION_MZONE,0,1,nil)
		elseif code==19800014 then
			return true
		else
			return false
		end
	end
	--pick effect
	e:SetLabel(code)
	local lcode=e:GetLabel()
	--Set parameters
	if lcode==19800005 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif lcode==19800007 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif lcode==19800009 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c19800019.analyzer,tp,LOCATION_SZONE,0,1,1,nil)
	elseif lcode==19800011 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	elseif lcode==19800014 then
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1600)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
	else
		return
	end
end
function c19800019.operation(e,tp,eg,ep,ev,re,r,rp)
	local lcode=e:GetLabel()
	--pilgrim
	if lcode==19800005 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19800019.pilgrim),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	--initializer
	elseif lcode==19800007 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19800019.initializer),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=sp:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		end
	--analyzer
	elseif lcode==19800009 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	--commander
	elseif lcode==19800011 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c19800019.commander,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	--lighthouse
	elseif lcode==19800014 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	-------
	else
		return
	end
end
	