--Comment section
--As the title says, this script contains the outdated effect of an AoJ card (more precisely, the Spell Card "The AoJ's Might").
--Originally, this card had an effect that made your opponent's monsters unable to declare an attack against the monsters in your possession.
--However, an opponent's monster could attack another opponent's monster.
--The effect has been changed, so I decided to preserve the old version. Note that the script might cause some bugs due to lack of playtesting.


--Script by XGlitchy30
function c19772593.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19772593,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c19772593.target)
	e1:SetOperation(c19772593.activate)
	c:RegisterEffect(e1)
	--effects (you could choose between: limit the opponent's monsters' attacks / increase your monsters' ATK)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19772593)
	e2:SetCondition(c19772593.econ)
	e2:SetCost(c19772593.ecost)
	e2:SetTarget(c19772593.etg)
	e2:SetOperation(c19772593.eop)
	c:RegisterEffect(e2)
end
--filters
function c19772593.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x197) and c:GetLevel()==4 and c:IsAbleToHand()
end
function c19772593.sumfilter(c,e,tp)
	return c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19772593.efilter(c)
	return c:IsFaceup() and c:IsCode(19772606)
end
function c19772593.attackable(c)
	return c:IsAttackable() or c:IsFacedown()
end
--Activate
function c19772593.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19772593.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19772593.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c19772593.sumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c19772593.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19772593.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		if Duel.IsExistingMatchingCard(c19772593.sumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19772593.sumfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--effects
function c19772593.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(c19772593.efilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19772593.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c19772593.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	op=Duel.SelectOption(tp,aux.Stringid(19772593,1),aux.Stringid(19772593,2))
	e:SetLabel(op)
end
function c19772593.eop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetOperation(c19772593.atklockop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif op==1 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x197))
		e2:SetValue(1000)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e3,tp)
	end
end
function c19772593.atklockop(e,tp,eg,ep,ev,re,r,rp)
	--prevent attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c19772593.btcon)
	e1:SetTarget(c19772593.btat2)
	e1:SetValue(c19772593.btat1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c19772593.btcon)
	e2:SetTarget(c19772593.btat2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	-----------
	local tc=Duel.GetAttacker()
	local g=Duel.GetMatchingGroup(c19772593.attackable,tp,0,LOCATION_MZONE,tc)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(19772593,14))
	local tg=g:Select(1-tp,1,1,tc):GetFirst()
	if not tg then return end
	Duel.CalculateDamage(tc,tg)
	local atka,defa=tc:GetAttack(),tc:GetDefense()
	local atkd,defd=tg:GetAttack(),tg:GetDefense()
	local dg=0
	local af=0
	--position check
	if tc:IsPosition(POS_FACEUP_ATTACK) and tg:IsPosition(POS_FACEUP_ATTACK) then
		dg=math.abs(atka-atkd)
		if atka>atkd then
			af=1
		elseif atka<atkd then
			af=2
		end
	--
	elseif tc:IsPosition(POS_FACEUP_ATTACK) and (tg:IsPosition(POS_FACEUP_DEFENSE) or tg:IsPosition(POS_FACEDOWN_DEFENSE)) then
		if tg:IsFacedown() then
			Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
		end
		dg=math.abs(atka-defd)
		if atka>defd then
			af=1
		end
	--
	elseif tc:IsPosition(POS_FACEUP_DEFENSE) and tg:IsPosition(POS_FACEUP_ATTACK) then
		dg=math.abs(defa-atkd)
		if defa>atkd then
			af=1
		elseif defa<atkd then
			af=2
		end
	--
	elseif tc:IsPosition(POS_FACEUP_DEFENSE) and (tg:IsPosition(POS_FACEUP_DEFENSE) or tg:IsPosition(POS_FACEDOWN_DEFENSE)) then
		if tg:IsFacedown() then
			Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
		end
		dg=math.abs(defa-defd)
		if defa>defd then
			af=1
		end
	else return end
	Duel.Damage(1-tp,dg,REASON_BATTLE)
	if af==1 then
		Duel.Destroy(tg,REASON_BATTLE)
	elseif af==2 then
		Duel.Destroy(tc,REASON_BATTLE)
	end
end
function c19772593.btcon(e,c)
	return Duel.GetFieldGroupCount(Duel.GetTurnPlayer(),LOCATION_MZONE,0)<=1
end
function c19772593.btat1(e,c)
	return c:GetControler()==1-Duel.GetTurnPlayer()
end
function c19772593.btat2(e,c)
	return c:GetControler()==Duel.GetTurnPlayer()
end