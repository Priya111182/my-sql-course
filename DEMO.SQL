-- Football Match exercise
 
/*
The FootballMatch table shows the EPL matches played in 2024/25 season as of 16th March 2025
 
Important Columns
Date - Match Date (dd/mm/yy)
Time - Time of match kick off
HomeTeam- Home Team
AwayTeam - Away Team
FTHG -Full Time Home Team Goals
FTAG - Full Time Away Team Goals
FTR - Full Time Result (H=Home Win, D=Draw, A=Away Win)
 
Full details at https://zomalex.co.uk/datasets/football_match_dataset.html
*/
 
SELECT
    fm.Date
    , fm.HomeTeam
    , fm.AwayTeam
    , fm.FTHG
    , fm.FTAG
    , fm.FTR
FROM
    FootballMatch fm
 
/*
How many games have been played?.  
- In total
- By each team
- By Month
*/
SELECT
datename(YEAR,date ) YEAR
    ,datename(Month,date ) MONTH
    
    ,MONTH(DATE)MonthNumber
    ,COUNT (*) AS NumberofMatches
FROM
    FootballMatch
GROUP BY DATENAME(MONTH,DATE),MONTH(DATE),datename(YEAR,date )
order by [YEAR] desc,[MonthNumber]desc;
 

-- How many goals have been scored in total
SELECT
    sum(FTHG)+sum(FTAG) AS TotalGoals
FROM
    FootballMatch
 
-- How many goals have been scored by each team?
;WITH
    CTE
    AS
    
    (
                    SELECT
                HomeTeam AS TEAM
,SUM(FTHG) AS TOTALGOALS
            FROM
                FootballMatch
            GROUP BY HomeTeam
        UNION ALL
            SELECT
                AWAYTEAM 
                ,SUM(FTAG)
            FROM
                FootballMatch
            GROUP BY AWAYTEAM
    )
SELECT
    CTE.TEAM
    ,SUM(CTE.TOTALGOALS) AS TOTALGOALS
FROM
    CTE
GROUP BY CTE.TEAM
ORDER BY CTE.TEAM

  DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam as Team
    , SUM(fm.FTHG) AS GF
     ,sum(ftag) as GA
INTO #LeagueTable
FROM
    FootballMatch fm
group by fm.HomeTeam
UNION ALL
SELECT
    fm.AwayTeam
    , SUM(fm.FTAG)
    , 1
FROM
    FootballMatch fm
group by fm.AwayTeam  
 
SELECT t.Team As Team,
    SUM(T.GF) as GF
    , SUM(T.GA) as GA
FROM #LeagueTable t
    group by t.Team
    order by t.Team
    
    
    
    DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam AS Team
    ,CASE WHEN fm.FTR = 'H' THEN 1  ELSE 0 END AS Won -- SERACHED CASE
    ,CASE fm.ftr WHEN 'D' THEN 1 ELSE 0 END AS Drawn -- simple CASE
    ,fm.FTHG AS GF
    ,fm.FTAG AS GA
INTO #LeagueTable
    FROM FootballMatch fm
UNION ALL
SELECT
    fm.AwayTeam
    ,CASE WHEN fm.FTR = 'A' THEN 1 ELSE 0 END AS Won
    ,CASE fm.ftr WHEN 'D' THEN 1 ELSE 0 END AS Drawn -- simple CASE
    ,fm.FTAG
    ,fm.FTHG
FROM  FootballMatch fm
 
--SELECT * FROM #LeagueTable;
 
SELECT
    t.Team AS Team
    ,count(*) AS Played
    ,SUM(t.Won) AS Won
    ,SUM(t.Drawn) AS Drawn
    ,SUM(T.GF) AS GF    
    ,SUM(T.GA) AS GA
FROM
    #LeagueTable t
GROUP BY t.Team
ORDER BY t.Team;
 