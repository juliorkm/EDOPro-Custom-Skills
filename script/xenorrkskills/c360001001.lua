--Vanilla Flavored Fusion
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function s.filter(c,e,tp)
	local rc=c:GetOriginalRace()
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(10) and not c:IsType(TYPE_EFFECT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,rc)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c,0x60)>0
end
function s.filter2(c,rc)
	return c:IsRace(rc)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return card to bottom
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_RULE)
	end
	--choose fusion monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g2:GetFirst()
	local rc=tc:GetOriginalRace()
	if not tc then return end
	tc:SetMaterial(nil)
	--choose monsters in gy or banish
	local g3=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil,rc)
	if #g3>0 then
		local ct=Duel.SendtoDeck(g3,nil,SEQ_DECKBOTTOM,REASON_RULE)
		Duel.SortDeckbottom(tp,tp,ct)
	end
	--summon
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP,0x60)
	--Cannot attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3206)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	tc:CompleteProcedure()
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end