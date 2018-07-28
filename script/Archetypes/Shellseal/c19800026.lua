--Cattura Gusciosigillo
--=£1G*
function c19800026.initial_effect(c)
	c:SetUniqueOnField(1,0,19800026)
	--Activate (normally)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(19800026,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate (with effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19800026,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c19800026.target)
	e1:SetOperation(c19800026.activate)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1x:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1x)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19800026.attrtg)
	e2:SetOperation(c19800026.attrop)
	c:RegisterEffect(e2)
end
--filters
function c19800026.filter(c,e,tp,atk)
	return c:GetSummonPlayer()==tp and c:GetBaseAttack()<=atk
		and (not e or (c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)))
end
function c19800026.ecount(c)
	return c:IsSetCard(0x1982) and c:IsFaceup()
end
function c19800026.eqfilter(c)
	return c:IsFaceup() and c:IsCode(19800001)
end
function c19800026.attrfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
--Activate
function c19800026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--check total atk
	local main=Duel.GetMatchingGroup(c19800026.ecount,tp,LOCATION_MZONE,0,nil)
	local total=0
	for i in aux.Next(main) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	------
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(c19800026.filter,1,nil,nil,1-tp,total) 
		and Duel.IsExistingMatchingCard(c19800026.eqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function c19800026.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c19800026.eqfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	--check total atk
	local main=Duel.GetMatchingGroup(c19800026.ecount,tp,LOCATION_MZONE,0,nil)
	local total=0
	for i in aux.Next(main) do
		local atk=i:GetAttack()
		if atk<0 then atk=0 end
		total=total+atk
	end
	------
	local g=eg:Filter(c19800026.filter,nil,nil,1-tp,total)
	if g:GetCount()>0 then
		local eq=Duel.GetMatchingGroup(c19800026.eqfilter,tp,LOCATION_MZONE,0,nil)
		if eq:GetCount()<=0 then return end
		local tc=nil
		if eq:GetCount()==1 then
			tc=eq:GetFirst()
		else
			tc=eq:Select(tp,1,1,nil)
		end
		if tc and tc:IsFaceup() then
			Duel.Equip(tp,g:GetFirst(),tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c19800026.eqlimit)
			e1:SetLabelObject(tc)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c19800026.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--change attribute
function c19800026.attrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19800026.attrfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19800026.attrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19800026.attrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c19800026.attrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
