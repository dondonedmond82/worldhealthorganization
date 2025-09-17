import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from dash import Dash, dcc, html, dash_table

# ===================== LOAD & CLEAN DATA =====================
df = pd.read_csv("./data/Health_Camp_Detail.csv")  # replace with your file path

# Convert dates
df['Camp_Start_Date'] = pd.to_datetime(df['Camp_Start_Date'])
df['Camp_End_Date'] = pd.to_datetime(df['Camp_End_Date'])

# Add duration column (in days)
df['Duration_Days'] = (df['Camp_End_Date'] - df['Camp_Start_Date']).dt.days
df['Year'] = df['Camp_Start_Date'].dt.year
df['Month'] = df['Camp_Start_Date'].dt.month_name()
df['YearMonth'] = df['Camp_Start_Date'].dt.to_period('M').astype(str)

# ===================== KPIs =====================
total_campaigns = len(df)
avg_duration = df['Duration_Days'].mean().round(1)
longest_duration = df['Duration_Days'].max()
shortest_duration = df['Duration_Days'].min()

# ===================== PLOTLY FIGURES =====================
# 1. Pie Chart: Distribution by Category1
fig_pie = px.pie(df, names='Category1', title="Campaigns by Category1", hole=0.4)

# 2. Bar Chart: Category2 breakdown
fig_bar = px.bar(df.groupby('Category2').size().reset_index(name='Count'),
                 x='Category2', y='Count',
                 title="Campaign Count by Category2")

# 3. Line Chart: Campaigns over time
fig_line = px.line(df.groupby('YearMonth').size().reset_index(name='Count'),
                   x='YearMonth', y='Count',
                   markers=True,
                   title="Number of Campaigns Over Time")

# 4. Heatmap: Campaign count by Year & Month
heatmap_data = df.groupby(['Year','Month']).size().reset_index(name='Count')
# Ensure months are ordered properly
month_order = ["January","February","March","April","May","June",
               "July","August","September","October","November","December"]
heatmap_data['Month'] = pd.Categorical(heatmap_data['Month'], categories=month_order, ordered=True)
heatmap_data = heatmap_data.pivot(index='Month', columns='Year', values='Count').fillna(0)

fig_heatmap = go.Figure(data=go.Heatmap(
    z=heatmap_data.values,
    x=heatmap_data.columns,
    y=heatmap_data.index,
    colorscale='Blues',
    hoverongaps=False
))
fig_heatmap.update_layout(title="Monthly Campaign Intensity (Heatmap)")

# ===================== DASH APP =====================
app = Dash(__name__)

app.layout = html.Div(style={'margin': '2rem'}, children=[
    html.H1("📊 Health Campaign Dashboard", style={"textAlign": "center"}),

    # KPI Section
    html.Div(style={'display': 'flex', 'justifyContent': 'space-around', 'marginBottom': '2rem'}, children=[
        html.Div([
            html.H3("Total Campaigns"),
            html.H2(f"{total_campaigns}")
        ], style={'backgroundColor': '#f8f9fa','padding': '1rem','borderRadius': '12px','width': '20%','textAlign':'center'}),
        html.Div([
            html.H3("Avg Duration (Days)"),
            html.H2(f"{avg_duration}")
        ], style={'backgroundColor': '#f8f9fa','padding': '1rem','borderRadius': '12px','width': '20%','textAlign':'center'}),
        html.Div([
            html.H3("Longest Duration"),
            html.H2(f"{longest_duration} days")
        ], style={'backgroundColor': '#f8f9fa','padding': '1rem','borderRadius': '12px','width': '20%','textAlign':'center'}),
        html.Div([
            html.H3("Shortest Duration"),
            html.H2(f"{shortest_duration} days")
        ], style={'backgroundColor': '#f8f9fa','padding': '1rem','borderRadius': '12px','width': '20%','textAlign':'center'})
    ]),

    # Charts Section (Grid)
    html.Div(style={'display': 'grid', 'gridTemplateColumns': '1fr 1fr', 'gap': '2rem'}, children=[
        dcc.Graph(figure=fig_pie),
        dcc.Graph(figure=fig_bar),
        dcc.Graph(figure=fig_line, style={'gridColumn': 'span 2'}),
        dcc.Graph(figure=fig_heatmap, style={'gridColumn': 'span 2'}),
    ]),

    # Data Table
    html.H2("📋 Campaign Details", style={'marginTop':'2rem'}),
    dash_table.DataTable(
        data=df.to_dict('records'),
        columns=[{"name": i, "id": i} for i in df.columns],
        page_size=10,
        filter_action='native',
        sort_action='native',
        style_table={'overflowX': 'auto'}
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
