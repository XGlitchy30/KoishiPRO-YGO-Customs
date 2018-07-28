--Protettore della Solfenice
--Script by XGlitchy30
function c27606975.initial_effect(c)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,27606975)
	e1:SetTarget(c27606975.reptg)
	e1:SetValue(c27606975.repval)
	e1:SetOperation(c27606975.repop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,27606975)
	e2:SetCondition(c27606975.sccon)
	e2:SetTarget(c27606975.sctg)
	e2:SetOperation(c27606975.scop)
	c:RegisterEffect(e2)
end
--filters
function c27606975.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsSetCard(0x3721) and c:IsAbleToGrave()
		and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and re:GetHandler():GetControler()~=tp
end
function c27606975.scfilter(c)
	return c:IsSetCard(0x3721) and c:GetLevel()<=5 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27606975.egfilter(c)
	return c:GetFlagEffect(27606975)>0
end
--protection
function c27606975.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c27606975.repfilter,1,nil,tp,re)
		and eg:GetCount()==1 
	end
	eg:GetFirst():RegisterFlagEffect(27606975,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1,0)
	return true
end
function c27606975.repval(e,c,re)
	return c27606975.repfilter(c,e:GetHandlerPlayer(),re)
end
function c27606975.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27606975)
	local egc=Duel.GetMatchingGroup(c27606975.egfilter,tp,LOCATION_ONFIELD,0,nil):GetFirst()
	local tc=re:GetHandler()
	if Duel.SendtoGrave(egc,REASON_EFFECT)~=0 then
		if tc and tc:IsControler(1-tp) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
--search
function c27606975.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
		and re:GetHandler():IsSetCard(0x3721) and not re:GetHandler():IsCode(27606975)
end
function c27606975.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27606975.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c27606975.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27606975.scfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end