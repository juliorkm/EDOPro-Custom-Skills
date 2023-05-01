--Ace Investor
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,aux.FALSE,nil, 1)
	aux.GlobalCheck(s,function()
		s[0]={}
		s[1]={}
		s[2]={}
		s[3]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			local p=Duel.GetTurnPlayer()
			s[p+2]={table.unpack(s[p])}
			s[p]={}
		end)
	end)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetRange(0x5f)
		e1:SetCountLimit(1)
		e1:SetOperation(s.op) 
		c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	Duel.RegisterEffect(e1,tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		table.insert(s[ep],2*ev)
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentPhase()==PHASE_END and Duel.IsTurnPlayer(tp) and #s[tp]>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--recover
	local sum = 0
	for i=#s[tp],1,-1 do
		sum = sum + table.remove(s[tp], i)
	end
	Duel.Recover(tp,sum,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end