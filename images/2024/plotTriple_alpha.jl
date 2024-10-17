include("TripleCascadeOld.jl")

Pkg.add("PGFPlots");using PGFPlots
pushPGFPlotsPreamble("\\usepackage{xfrac}")
pushPGFPlotsOptions("scale=0.55")
Fnu=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"\frac{F_{NU}}{P}, \text{кг}",
xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.08,.925)},rotate=270,anchor=south}")
pFo=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"\delta(\frac{F_{NU}}{P}), \%",
xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.1,.925)},rotate=270,anchor=south}")

L_sum_plot=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"\frac{L}{P}",
xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.08,.925)},rotate=270,anchor=south}")
SWU_plot=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"\frac{\Delta A}{P}",
xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.08,.925)},rotate=270,anchor=south}")
SWU_loss_plot=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"\delta(\frac{\Delta A}{P}), \%", xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.13,.925)},rotate=270,anchor=south}")

C232P=PGFPlots.Axis(style="width=12cm, height=12cm, line width=2pt", xlabel = L"\alpha", ylabel=L"C_{232,P}\cdot10^{7}, \%",
xlabelStyle ="{at={(axis description cs:.86,0)}}", ylabelStyle ="{at={(axis description cs:-0.08,.925)},rotate=270,anchor=south}")

α_range = []
Fnu_range = []
pFo_range = []
SWU_range = []
SWU_loss_range = []
L_sum_range = []

@showprogress for α in 0:0.1:0.9
# @showprogress for α in 0:0.4:0.8
# @showprogress for α in 0:0.05:0.95

    sc=Opt_Triple(Mₖ₁, Mₖ₂, RepUFeed, Cₙᴾʳᵒᵈᵘᶜᵗ, RepU➗LEUᴾʳᵒᵈᵘᶜᵗ, F₀, KKR, PDK; criteria=NatU➗LEUᴾʳᵒᵈᵘᶜᵗ, α=α).scheme
    df=sc(1)

    global α_range = push!(α_range, α)
    global SWU_range = push!(SWU_range, last(df.ЕРР))
    global SWU_loss_range = push!(SWU_loss_range, last(df.Потери_РР_pct))

    global Fnu_range = push!(Fnu_range, last(df.сырье_разбавителя))
    global pFo_range = push!(pFo_range, last(df.Экономия_природного_Урана_pct))
    global L_sum_range = push!(L_sum_range, last(df.L_sum))
    XLSX.writetable("Tables\\alpha_is_$α.xlsx", df, overwrite=true, anchor_cell="A3")    
end

α_rangeR=Array{Float64}(α_range)
SWU_rangeR=Array{Float64}(SWU_range)
SWU_lossR=Array{Float64}(SWU_loss_range)
Fnu_rangeR=Array{Float64}(Fnu_range)
pFo_rangeR=Array{Float64}(pFo_range)
L_sum_rangeR=Array{Float64}(L_sum_range)

push!(SWU_loss_plot, PGFPlots.Linear(α_rangeR, SWU_lossR, mark="none"))
save("Plots\\SW_loss.tex", SWU_loss_plot, include_preamble=false)

push!(SWU_plot, PGFPlots.Linear(α_rangeR, SWU_rangeR, mark="none"))
save("Plots\\SW.tex", SWU_plot, include_preamble=false)

push!(Fnu, PGFPlots.Linear(α_rangeR, Fnu_rangeR, mark="none"))
save("Plots\\Fnu.tex", Fnu, include_preamble=false)

push!(pFo, PGFPlots.Linear(α_rangeR, pFo_rangeR, mark="none"))
save("Plots\\pFo.tex", pFo, include_preamble=false)

push!(L_sum_plot, PGFPlots.Linear(α_rangeR, L_sum_rangeR, mark="none"))
save("Plots\\L_sum.tex", L_sum_plot, include_preamble=false)