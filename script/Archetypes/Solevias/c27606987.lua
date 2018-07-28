--Origine della Solfenice
--Script by XGlitchy30
function c27606987.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c27606987.xyzfilter,c27606987.xyzcheck,2,2,c27606987.fxfilter,aux.Stringid(43490025,1))
	c:SetUniqueOnField(1,0,27606987)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c27606987.protcon)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1x:SetValue(aux.tgoval)
	c:RegisterEffect(e1x)
	--multiple effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c27606987.tgcost)
	e3:SetTarget(c27606987.tgtg)
	e3:SetOperation(c27606987.tgop)
	c:RegisterEffect(e3)
end
--filters
function c27606987.xyzfilter(c,xyzc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3721) and c:GetRank()==6 
end
function c27606987.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)>1
end
function c27606987.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3721)
end
function c27606987.ovcheck(c)
	return c:IsCode(27606982,27606983,27606984,27606985,27606986,27606988)
end
function c27606987.fxfilter(c) --added to fix the normal xyz proc
	return c:IsFaceup() and c:IsSetCard(0x3721) and c:GetRank()>14 and Duel.GetFlagEffect(27606987)>100
end
--case 82
function c27606987.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
--case 84
function c27606987.tg(e,c)
	return c:IsSetCard(0x3721)
end
--case 85
function c27606987.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	return e:GetHandler():IsRelateToBattle()
end
function c27606987.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c27606987.atkop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--case 86
function c27606987.filter(c)
	return aux.disfilter1(c) and c:IsFaceup()
end
--case 88
function c27606987.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3721) and not c:IsCode(27606988)
end
--protection
function c27606987.protcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27606987.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
--multiple effects
function c27606987.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(c27606987.ovcheck,1,nil)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local code=Duel.GetOperatedGroup():GetFirst():GetCode()
	if Duel.GetOperatedGroup():GetCount()==1 then
		if code==27606982 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,0))
			e:SetLabel(82)
		elseif code==27606983 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,1))
			e:SetLabel(83)
		elseif code==27606984 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,2))
			e:SetLabel(84)
		elseif code==27606985 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,3))
			e:SetLabel(85)
		elseif code==27606986 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,4))
			e:SetLabel(86)
		elseif code==27606988 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(27606987,5))
			e:SetLabel(88)
		else return end
	end
end
function c27606987.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==82 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,1,nil,tp,LOCATION_DECK)
	elseif e:GetLabel()==83 then
		e:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,1,nil,tp,LOCATION_ONFIELD)
	elseif e:GetLabel()==86 then
		e:SetCategory(CATEGORY_DISABLE)
	elseif e:GetLabel()==88 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c27606987.ovfilter),tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	else return end
end
function c27606987.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local case=e:GetLabel()
	-------
	if case==82 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c27606987.tgfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				local atk=Duel.GetOperatedGroup():GetFirst():GetAttack()
				local def=Duel.GetOperatedGroup():GetFirst():GetDefense()
				if c:IsRelateToEffect(e) and c:IsFaceup() then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(atk)
					e1:SetReset(RESET_EVENT+0x1ff0000)
					c:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					e2:SetValue(def)
					c:RegisterEffect(e2)
				end
			end
		end
	-------
	elseif case==83 then
		if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	-------
	elseif case==84 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTarget(c27606987.tg)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTarget(c27606987.tg)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_REMOVE)
		e3:SetTarget(c27606987.tg)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetValue(1)
		Duel.RegisterEffect(e3,tp)
	-------
	elseif case==85 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(34408491,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_DAMAGE)
		e1:SetCondition(c27606987.atkcon)
		e1:SetTarget(c27606987.atktg)
		e1:SetOperation(c27606987.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	-------
	elseif case==86 then
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local g=Duel.GetMatchingGroup(c27606987.negfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			tc=g:GetNext()
		end
	-------
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end
		