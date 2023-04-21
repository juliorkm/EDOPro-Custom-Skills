--A New Life - Galatea
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={TOKEN_WORLD_LEGACY}
s.listed_series={0x11b,0xfe}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69811711,0xfe,TYPES_TOKEN,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,69811711,0xfe,TYPES_TOKEN,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and (Duel.IsExistingMatchingCard(s.wlfilter,tp,LOCATION_HAND,0,1,nil)
			or Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_HAND,0,2,nil))
end
function s.wlfilter(c)
	return c:IsSetCard(0xfe) and not c:IsPublic()
end
function s.mfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsSetCard(0xfe) and not c:IsPublic()
end
function s.filter(c)
	return (c:IsSetCard(0xfe) or c:IsRace(RACE_MACHINE)) and not c:IsPublic()
end
function s.transfilter(c)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x11b)) and c:IsMonster()
end
function s.rescon(sg,e,tp,mg,c)
	return (sg:IsExists(s.wlfilter,1,nil) and #sg==1) or (sg:FilterCount(s.mfilter,1,nil)==2)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return card to bottom
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	--reveal card(s)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,2,s.rescon,1,tp,HINTMSG_CONFIRM,s.rescon,nil,true)
	Duel.ConfirmCards(1-tp,sg)
	--summon tokens
	local t1=Duel.CreateToken(tp,69811711)
	local t2=Duel.CreateToken(tp,69811711)
	Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonStep(t2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
	--transform token
	if sg:IsExists(s.transfilter,1,nil) then
		Duel.Hint(HINT_CARD,tp,136000004)
		t1:Recreate(136000004,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
	--cannot special summon link-3+ monsters for rest of turn except girsu
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsMonster() then
		return c:IsType(TYPE_LINK) and c:GetLink()>=3 and not c:IsCode(30194529) and not c:IsCode(76145142)
	else
		return c:IsOriginalType(TYPE_LINK) and c:GetLink()>=3 and not c:IsCode(30194529) and not c:IsCode(76145142)
	end
end