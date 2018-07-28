--Guerriero Prescelto della Solfenice
--Script by XGlitchy30
function c27606988.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3721),6,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c27606988.condition)
	e1:SetTarget(c27606988.target)
	e1:SetOperation(c27606988.operation)
	c:RegisterEffect(e1)
	--damage change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c27606988.damgeneric)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_SINGLE)
	e2x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2x:SetRange(LOCATION_MZONE)
	e2x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2x:SetCondition(c27606988.damgeneric)
	e2x:SetValue(1)
	c:RegisterEffect(e2x)
	local e2y=Effect.CreateEffect(c)
	e2y:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2y:SetRange(LOCATION_MZONE)
	e2y:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2y:SetCondition(c27606988.damcon)
	e2y:SetOperation(c27606988.damop)
	c:RegisterEffect(e2y)
	local e2z=Effect.CreateEffect(c)
	e2z:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2z:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2z:SetRange(LOCATION_MZONE)
	e2z:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2z:SetCountLimit(1)
	e2z:SetCondition(c27606988.dspsum)
	e2z:SetTarget(c27606988.dspsumtg)
	e2z:SetOperation(c27606988.dspusmop)
	c:RegisterEffect(e2z)
	--to GY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c27606988.tgcost)
	e3:SetTarget(c27606988.tgtg)
	e3:SetOperation(c27606988.tgop)
	c:RegisterEffect(e3)
	--recover resources
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c27606988.sccon)
	e4:SetTarget(c27606988.sctg)
	e4:SetOperation(c27606988.scop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c27606988.desreptg)
	e5:SetOperation(c27606988.desrepop)
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
end
--filters
function c27606988.eqfilter(c)
	return c:IsCode(27606961)
end
function c27606988.spfilter(c,e,tp)
	return c:IsCode(27606962) --and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c27606988.dmcheck(c)
	return c:IsSetCard(0x3721) and c:GetLevel()==10
end
--equip
function c27606988.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c27606988.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c27606988.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c27606988.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c27606988.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function c27606988.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tc=Duel:GetFirstTarget()
	if ft1<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if not Duel.Equip(tp,tc,c,true,true) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(27606988,RESET_EVENT+0x1fe0000,0,0)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c27606988.eqlimit)
	tc:RegisterEffect(e1)
	Duel.EquipComplete()
end
function c27606988.eqlimit(e,c)
	return e:GetOwner()==c
end
--damage change (equip effects)
function c27606988.damgeneric(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(c27606988.dmcheck,1,nil)
end
function c27606988.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler() and ep~=tp and e:GetHandler():GetEquipGroup():IsExists(c27606988.dmcheck,1,nil)
end
function c27606988.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,2000)
end
function c27606988.dspsum(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetEquipGroup():IsExists(c27606988.dmcheck,1,nil)
end
function c27606988.dspsumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27606988.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c27606988.dspusmop(e,tp,eg,ep,ev,re,r,rp)
	local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft2<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606988.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
--to GY
function c27606988.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c27606988.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():GetCount()>0
		and e:GetHandler():GetEquipGroup():Filter(Card.IsAbleToGrave,nil):GetCount()==e:GetHandler():GetEquipGroup():GetCount()
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function c27606988.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqg=c:GetEquipGroup()
	if eqg:GetCount()<=0 then return end
	local eqf=eqg:Filter(Card.IsAbleToGrave,nil)
	if eqf:GetCount()<eqg:GetCount() then return end
	if Duel.SendtoGrave(eqf,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
--recover resources
function c27606988.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c27606988.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c27606988.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
--Destroy replace
function c27606988.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=e:GetLabelObject():GetLabelObject()
	if chk==0 then return ec and ec:IsHasCardTarget(c) and ec:GetFlagEffect(27606988)~=0
		and ec:IsDestructable(e) and not ec:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c27606988.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject():GetLabelObject(),REASON_EFFECT+REASON_REPLACE)
end