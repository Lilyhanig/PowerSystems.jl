using PowerSystems
using TimeSeries
using Missings

dates  = DateTime(today())

FiveBus = SystemParam(5, 230, 100, 1);

nodes    = [Bus(1,"nodeA", "PV", 0, 1.0, (1.05, 0.9), 230),
            Bus(2,"nodeB", "PQ", 0, 1.0, (1.05, 0.9), 230),
            Bus(3,"nodeC", "PV", 0, 1.0, (1.05, 0.9), 230),
            Bus(4,"nodeD", "PV", 0, 1.0, (1.05, 0.9), 230),
            Bus(5,"nodeE", "SF", 0, 1.0, (1.05, 0.9), 230),
        ];

Branches = [Line("1", true, (nodes[1],nodes[2]), 0.00281, 0.0281, 0.00712, 400.0, missing),
            Line("2", true, (nodes[1],nodes[4]), 0.00304, 0.0304, 0.00658, Inf, missing),
            Line("3", true, (nodes[1],nodes[5]), 0.00064, 0.0064, 0.03126, Inf, missing),
            Line("4", true, (nodes[2],nodes[3]), 0.00108, 0.0108, 0.01852, Inf, missing),     
            Line("5", true, (nodes[3],nodes[4]), 0.00297, 0.0297, 0.00674, Inf, missing),
            Line("6", true, (nodes[4],nodes[5]), 0.00297, 0.0297, 0.00674, 240, missing)
];     

Net = Network(FiveBus, Branches, nodes); 

Generators = [  ThermalGen("Alta", true, nodes[1],
                TechGen(40, (0, 40), 10, (-30, 30), missing, missing),
                EconGen(40, 14.0, 0.0, 0.0, 0.0, missing)
                ), 
                ThermalGen("Park City", true, nodes[1],
                TechGen(170, (0, 170), 20, (-127.5, 127.5), missing, missing),
                EconGen(170, 15.0, 0.0, 0.0, 0.0, missing)
                ), 
                ThermalGen("Solitude", true, nodes[3],
                TechGen(520, (0, 520), 100, (-390, 390), missing, missing),
                EconGen(520, 30.0, 0.0, 0.0, 0.0, missing)
                ),                
                ThermalGen("Sundance", true, nodes[4],
                TechGen(200, (0, 200), 40, (-150, 150), missing, missing),
                (EconGen(200, 40.0, 0.0, 0.0, 0.0, missing))
                ),    
                ThermalGen("Brighton", true, nodes[5],
                TechGen(600, (0, 600), 150, (-450, 450), missing, missing),
                EconGen(600, 10.0, 0.0, 0.0, 0.0, missing)
                )
            ];
            
Loads = [   StaticLoad("Bus2", nodes[2], "P", 300, 98.61, TimeArray(DateTime(today()), [1.0])),
            StaticLoad("Bus3", nodes[3], "P", 300, 98.61, TimeArray(DateTime(today()), [1.0])),
            StaticLoad("Bus4", nodes[4], "P", 400, 131.47, TimeArray(DateTime(today()), [1.0])),
        ]
            