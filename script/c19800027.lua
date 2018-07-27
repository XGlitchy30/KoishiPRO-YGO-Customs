--Gusciosigillo - Angelo Alato
--=£1G*
function c19800027.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c19800027.lcheck)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c19800027.valcheck)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c19800027.linklimit)
	c:RegisterEffect(e1)
	--protection
	local e1x=Effect.CreateEffect(c)
	e1x:SetType(EFFECT_TYPE_SINGLE)
	e1x:SetCode(EFFECT_IMMUNE_EFFECT)
	e1x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1x:SetRange(LOCATION_MZONE)
	e1x:SetLabelObject(e0)
	e1x:SetCondition(c19800027.econ)
	e1x:SetValue(c19800027.efilter)
	c:RegisterEffect(e1x)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c19800027.tgtg)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--unaffected
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19800027,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,19800027)
	e3:SetCondition(c19800027.discon)
	e3:SetOperation(c19800027.disop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19800027,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,11800027)
	e4:SetCondition(c19800027.dgcon)
	e4:SetCost(c19800027.dgcost)
	e4:SetTarget(c19800027.dgtg)
	e4:SetOperation(c19800027.dgop)
	c:RegisterEffect(e4)
end
--filters
function c19800027.lcheck(g,lc)
	return g:IsExists(c19800027.lfilter1,1,nil,g)
end
function c19800027.lfilter1(c,g)
	return c:IsCode(19800001) and g:IsExists(c19800027.lfilter2,1,nil,g,c) 
end
function c19800027.lfilter2(c,g,card1)
	return c:IsCode(19800001) and g:IsExists(c19800027.lfilter3,1,nil,g,c,card1) and c~=card1
end
function c19800027.lfilter3(c,card11,card2)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x1982) and c~=card11 and c~=card2
end
function c19800027.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c19800027.filter2(c)
	return c19800027.filter(c) and c:IsAbleToGrave()
end
--mat check
function c19800027.valcheck(e,c)
	local g=c:GetMaterial()
	local total=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsSetCard(0x1982) then
			local atk=tc:GetAttack()
			if atk<0 then atk=0 end
			total=total+atk
		end
		tc=g:GetNext()
	end
	e:SetLabel(total)
end
--spsummon condition
function c19800027.linklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--protection
function c19800027.econ(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c19800027.efilter(e,re)
	local total=e:GetLabelObject():GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetBaseAttack()<total
end
--change attribute
function c19800027.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and not c:IsSetCard(0x1982)
end
--unaffected
function c19800027.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c19800027.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c19800027.efilter_chain)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	c:RegisterEffect(e1,true)
end
function c19800027.efilter_chain(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
--damage
function c19800027.dgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19800027.filter,tp,0,LOCATION_MZONE,1,nil)
end
function c19800027.dgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19800027.dgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19800027.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function c19800027.dgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c19800027.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end