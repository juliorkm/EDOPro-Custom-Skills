--Ace Investor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.healcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.healop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(tp,s[tp]/4,REASON_RULE)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	s[p]=s[p]+ev
	--update player hint for amount paid
    local ce=Duel.IsPlayerAffectedByEffect(p,id)
    if ce then
        local nce=ce:Clone()
        ce:Reset()
        nce:SetDescription(s.lpstr(s[p]))
        Duel.RegisterEffect(nce,p)
    end
    local ce=Duel.IsPlayerAffectedByEffect(p,id)
    if ce then
        local nce=ce:Clone()
        ce:Reset()
        nce:SetDescription(s.lpstr(s[p]))
        Duel.RegisterEffect(nce,p)
    end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return s[tp]>=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--add end phase recover
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.healcon)
	e1:SetOperation(s.healop)
	Duel.RegisterEffect(e1,tp)
    --player hint for amount paid
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e2:SetDescription(s.lpstr(s[tp]))
    e2:SetCode(id)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
end
function s.lpstr(lp)
	if lp>=10000 then return aux.Stringid(id,15) end
	if lp>=9000 then return aux.Stringid(id,14) end
	if lp>=8500 then return aux.Stringid(id,13) end
	if lp>=8000 then return aux.Stringid(id,12) end
	if lp>=7500 then return aux.Stringid(id,11) end
	if lp>=7000 then return aux.Stringid(id,10) end
	if lp>=6500 then return aux.Stringid(id,9) end
	if lp>=6000 then return aux.Stringid(id,8) end
	if lp>=5500 then return aux.Stringid(id,7) end
	if lp>=5000 then return aux.Stringid(id,6) end
	if lp>=4500 then return aux.Stringid(id,5) end
	if lp>=4000 then return aux.Stringid(id,4) end
	if lp>=3500 then return aux.Stringid(id,3) end
	if lp>=3000 then return aux.Stringid(id,2) end
	if lp>=2500 then return aux.Stringid(id,1) end
	if lp>=2000 then return aux.Stringid(id,0) end
end