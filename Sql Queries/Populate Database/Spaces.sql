USE [ASDF-Palace]
GO

/*
400 rooms
5 elevators
5*4 = 20 Corridors
6 bars
4 restaurants
10 meeting rooms
4 gyms
10 saunas
1 hair salon
= 460 Spaces
*/
INSERT INTO [dbo].[Spaces]
           ([title]
           ,[beds]
           ,[location])
     VALUES
		   ('Room1',2,'101n'),
		   ('Room2',4,'102n'),
		   ('Room3',2,'103n'),
		   ('Room4',2,'104n'),
		   ('Room5',2,'105n'),
		   ('Room6',3,'106n'),
		   ('Room7',4,'107n'),
		   ('Room8',5,'108n'),
		   ('Room9',5,'109n'),
		   ('Room10',3,'110n'),
		   ('Room11',3,'111n'),
		   ('Room12',2,'112n'),
		   ('Room13',2,'113n'),
		   ('Room14',2,'114n'),
		   ('Room15',4,'115n'),
		   ('Room16',4,'116n'),
		   ('Room17',6,'117n'),
		   ('Room18',3,'118n'),
		   ('Room19',3,'119n'),
		   ('Room20',2,'120n'),

		   ('Room21',2,'101s'),
		   ('Room22',3,'102s'),
		   ('Room23',5,'103s'),
		   ('Room24',4,'104s'),
		   ('Room25',4,'105s'),
		   ('Room26',4,'106s'),
		   ('Room27',3,'107s'),
		   ('Room28',3,'108s'),
		   ('Room29',2,'109s'),
		   ('Room30',2,'110s'),
		   ('Room31',2,'111s'),
		   ('Room32',5,'112s'),
		   ('Room33',5,'113s'),
		   ('Room34',5,'114s'),
		   ('Room35',6,'115s'),
		   ('Room36',6,'116s'),
		   ('Room37',6,'117s'),
		   ('Room38',2,'118s'),
		   ('Room39',2,'119s'),
		   ('Room40',2,'120s'),

		   ('Room41',3,'101e'),
		   ('Room42',3,'102e'),
		   ('Room43',3,'103e'),
		   ('Room44',3,'104e'),
		   ('Room45',3,'105e'),
		   ('Room46',2,'106e'),
		   ('Room47',2,'107e'),
		   ('Room48',2,'108e'),
		   ('Room49',2,'109e'),
		   ('Room50',2,'110e'),
		   ('Room51',2,'111e'),
		   ('Room52',2,'112e'),
		   ('Room53',2,'113e'),
		   ('Room54',4,'114e'),
		   ('Room55',4,'115e'),
		   ('Room56',4,'116e'),
		   ('Room57',4,'117e'),
		   ('Room58',4,'118e'),
		   ('Room59',4,'119e'),
		   ('Room60',4,'120e'),

		   ('Room61',8,'101w'),
		   ('Room62',8,'102w'),
		   ('Room63',8,'103w'),
		   ('Room64',8,'104w'),
		   ('Room65',2,'105w'),
		   ('Room66',2,'106w'),
		   ('Room67',2,'107w'),
		   ('Room68',2,'108w'),
		   ('Room69',2,'109w'),
		   ('Room70',3,'110w'),
		   ('Room71',3,'111w'),
		   ('Room72',3,'112w'),
		   ('Room73',3,'113w'),
		   ('Room74',4,'114w'),
		   ('Room75',4,'115w'),
		   ('Room76',4,'116w'),
		   ('Room77',4,'117w'),
		   ('Room78',5,'118w'),
		   ('Room79',5,'119w'),
		   ('Room80',4,'120w'),

		   ('Room81',2,'201n'),
		   ('Room82',4,'202n'),
		   ('Room83',2,'203n'),
		   ('Room84',2,'204n'),
		   ('Room85',2,'205n'),
		   ('Room86',3,'206n'),
		   ('Room87',4,'207n'),
		   ('Room88',5,'208n'),
		   ('Room89',5,'209n'),
		   ('Room90',3,'210n'),
		   ('Room91',3,'211n'),
		   ('Room92',2,'212n'),
		   ('Room93',2,'213n'),
		   ('Room94',2,'214n'),
		   ('Room95',4,'215n'),
		   ('Room96',4,'216n'),
		   ('Room97',6,'217n'),
		   ('Room98',3,'218n'),
		   ('Room99',3,'219n'),
		   ('Room100',2,'220n'),

		   ('Room101',2,'201s'),
		   ('Room102',3,'202s'),
		   ('Room103',5,'203s'),
		   ('Room104',4,'204s'),
		   ('Room105',4,'205s'),
		   ('Room106',4,'206s'),
		   ('Room107',3,'207s'),
		   ('Room108',3,'208s'),
		   ('Room109',2,'209s'),
		   ('Room110',2,'210s'),
		   ('Room111',2,'211s'),
		   ('Room112',5,'212s'),
		   ('Room113',5,'213s'),
		   ('Room114',5,'214s'),
		   ('Room115',6,'215s'),
		   ('Room116',6,'216s'),
		   ('Room117',6,'217s'),
		   ('Room118',2,'218s'),
		   ('Room119',2,'219s'),
		   ('Room120',2,'220s'),

		   ('Room121',3,'201e'),
		   ('Room122',3,'202e'),
		   ('Room123',3,'203e'),
		   ('Room124',3,'204e'),
		   ('Room125',3,'205e'),
		   ('Room126',2,'206e'),
		   ('Room127',2,'207e'),
		   ('Room128',2,'208e'),
		   ('Room129',2,'209e'),
		   ('Room130',2,'210e'),
		   ('Room131',2,'211e'),
		   ('Room132',2,'212e'),
		   ('Room133',2,'213e'),
		   ('Room134',4,'214e'),
		   ('Room135',4,'215e'),
		   ('Room136',4,'216e'),
		   ('Room137',4,'217e'),
		   ('Room138',4,'218e'),
		   ('Room139',4,'219e'),
		   ('Room140',4,'220e'),

		   ('Room141',8,'201w'),
		   ('Room142',8,'202w'),
		   ('Room143',8,'203w'),
		   ('Room144',8,'204w'),
		   ('Room145',2,'205w'),
		   ('Room146',2,'206w'),
		   ('Room147',2,'207w'),
		   ('Room148',2,'208w'),
		   ('Room149',2,'209w'),
		   ('Room150',3,'210w'),
		   ('Room151',3,'211w'),
		   ('Room152',3,'212w'),
		   ('Room153',3,'213w'),
		   ('Room154',4,'214w'),
		   ('Room155',4,'215w'),
		   ('Room156',4,'216w'),
		   ('Room157',4,'217w'),
		   ('Room158',5,'218w'),
		   ('Room159',5,'219w'),
		   ('Room160',4,'220w'),
		
		   ('Room161',2,'301n'),
		   ('Room162',4,'302n'),
		   ('Room163',2,'303n'),
		   ('Room164',2,'304n'),
		   ('Room165',2,'305n'),
		   ('Room166',3,'306n'),
		   ('Room167',4,'307n'),
		   ('Room168',5,'308n'),
		   ('Room169',5,'309n'),
		   ('Room170',3,'310n'),
		   ('Room171',3,'311n'),
		   ('Room172',2,'312n'),
		   ('Room173',2,'313n'),
		   ('Room174',2,'314n'),
		   ('Room175',4,'315n'),
		   ('Room176',4,'316n'),
		   ('Room177',6,'317n'),
		   ('Room178',3,'318n'),
		   ('Room179',3,'319n'),
		   ('Room180',2,'320n'),

		   ('Room181',2,'301s'),
		   ('Room182',3,'302s'),
		   ('Room183',5,'303s'),
		   ('Room184',4,'304s'),
		   ('Room185',4,'305s'),
		   ('Room186',4,'306s'),
		   ('Room187',3,'307s'),
		   ('Room188',3,'308s'),
		   ('Room189',2,'309s'),
		   ('Room190',2,'310s'),
		   ('Room191',2,'311s'),
		   ('Room192',5,'312s'),
		   ('Room193',5,'313s'),
		   ('Room194',5,'314s'),
		   ('Room195',6,'315s'),
		   ('Room196',6,'316s'),
		   ('Room197',6,'317s'),
		   ('Room198',2,'318s'),
		   ('Room199',2,'319s'),
		   ('Room200',2,'320s'),

		   ('Room201',3,'301e'),
		   ('Room202',3,'302e'),
		   ('Room203',3,'303e'),
		   ('Room204',3,'304e'),
		   ('Room205',3,'305e'),
		   ('Room206',2,'306e'),
		   ('Room207',2,'307e'),
		   ('Room208',2,'308e'),
		   ('Room209',2,'309e'),
		   ('Room210',2,'310e'),
		   ('Room211',2,'311e'),
		   ('Room212',2,'312e'),
		   ('Room213',2,'313e'),
		   ('Room214',4,'314e'),
		   ('Room215',4,'315e'),
		   ('Room216',4,'316e'),
		   ('Room217',4,'317e'),
		   ('Room218',4,'318e'),
		   ('Room219',4,'319e'),
		   ('Room220',4,'320e'),
		
		   ('Room221',8,'301w'),
		   ('Room222',8,'302w'),
		   ('Room223',8,'303w'),
		   ('Room224',8,'304w'),
		   ('Room225',2,'305w'),
		   ('Room226',2,'306w'),
		   ('Room227',2,'307w'),
		   ('Room228',2,'308w'),
		   ('Room229',2,'309w'),
		   ('Room230',3,'310w'),
		   ('Room231',3,'311w'),
		   ('Room232',3,'312w'),
		   ('Room233',3,'313w'),
		   ('Room234',4,'314w'),
		   ('Room235',4,'315w'),
		   ('Room236',4,'316w'),
		   ('Room237',4,'317w'),
		   ('Room238',5,'318w'),
		   ('Room239',5,'319w'),
		   ('Room240',4,'320w'),

		   ('Room241',2,'401n'),
		   ('Room242',4,'402n'),
		   ('Room243',2,'403n'),
		   ('Room244',2,'404n'),
		   ('Room245',2,'405n'),
		   ('Room246',3,'406n'),
		   ('Room247',4,'407n'),
		   ('Room248',5,'408n'),
		   ('Room249',5,'409n'),
		   ('Room250',3,'410n'),
		   ('Room251',3,'411n'),
		   ('Room252',2,'412n'),
		   ('Room253',2,'413n'),
		   ('Room254',2,'414n'),
		   ('Room255',4,'415n'),
		   ('Room256',4,'416n'),
		   ('Room257',6,'417n'),
		   ('Room258',3,'418n'),
		   ('Room259',3,'419n'),
		   ('Room260',2,'420n'),

		   ('Room261',2,'401s'),
		   ('Room262',3,'402s'),
		   ('Room263',5,'403s'),
		   ('Room264',4,'404s'),
		   ('Room265',4,'405s'),
		   ('Room266',4,'406s'),
		   ('Room267',3,'407s'),
		   ('Room268',3,'408s'),
		   ('Room269',2,'409s'),
		   ('Room270',2,'410s'),
		   ('Room271',2,'411s'),
		   ('Room272',5,'412s'),
		   ('Room273',5,'413s'),
		   ('Room274',5,'414s'),
		   ('Room275',6,'415s'),
		   ('Room276',6,'416s'),
		   ('Room277',6,'417s'),
		   ('Room278',2,'418s'),
		   ('Room279',2,'419s'),
		   ('Room280',2,'420s'),

		   ('Room281',3,'401e'),
		   ('Room282',3,'402e'),
		   ('Room283',3,'403e'),
		   ('Room284',3,'404e'),
		   ('Room285',3,'405e'),
		   ('Room286',2,'406e'),
		   ('Room287',2,'407e'),
		   ('Room288',2,'408e'),
		   ('Room289',2,'409e'),
		   ('Room290',2,'410e'),
		   ('Room291',2,'411e'),
		   ('Room292',2,'412e'),
		   ('Room293',2,'413e'),
		   ('Room294',4,'414e'),
		   ('Room295',4,'415e'),
		   ('Room296',4,'416e'),
		   ('Room297',4,'417e'),
		   ('Room298',4,'418e'),
		   ('Room299',4,'419e'),
		   ('Room300',4,'420e'),

		   ('Room301',8,'401w'),
		   ('Room302',8,'402w'),
		   ('Room303',8,'403w'),
		   ('Room304',8,'404w'),
		   ('Room305',2,'405w'),
		   ('Room306',2,'406w'),
		   ('Room307',2,'407w'),
		   ('Room308',2,'408w'),
		   ('Room309',2,'409w'),
		   ('Room310',3,'410w'),
		   ('Room311',3,'411w'),
		   ('Room312',3,'412w'),
		   ('Room313',3,'413w'),
		   ('Room314',4,'414w'),
		   ('Room315',4,'415w'),
		   ('Room316',4,'416w'),
		   ('Room317',4,'417w'),
		   ('Room318',5,'418w'),
		   ('Room319',5,'419w'),
		   ('Room320',4,'420w'),

		   ('Room321',2,'501n'),
		   ('Room322',4,'502n'),
		   ('Room323',2,'503n'),
		   ('Room324',2,'504n'),
		   ('Room325',2,'505n'),
		   ('Room326',3,'506n'),
		   ('Room327',4,'507n'),
		   ('Room328',5,'508n'),
		   ('Room329',5,'509n'),
		   ('Room330',3,'510n'),
		   ('Room331',3,'511n'),
		   ('Room332',2,'512n'),
		   ('Room333',2,'513n'),
		   ('Room334',2,'514n'),
		   ('Room335',4,'515n'),
		   ('Room336',4,'516n'),
		   ('Room337',6,'517n'),
		   ('Room338',3,'518n'),
		   ('Room339',3,'519n'),
		   ('Room340',2,'520n'),

		   ('Room341',2,'501s'),
		   ('Room342',3,'502s'),
		   ('Room343',5,'503s'),
		   ('Room344',4,'504s'),
		   ('Room345',4,'505s'),
		   ('Room346',4,'506s'),
		   ('Room347',3,'507s'),
		   ('Room348',3,'508s'),
		   ('Room349',2,'509s'),
		   ('Room350',2,'510s'),
		   ('Room351',2,'511s'),
		   ('Room352',5,'512s'),
		   ('Room353',5,'513s'),
		   ('Room354',5,'514s'),
		   ('Room355',6,'515s'),
		   ('Room356',6,'516s'),
		   ('Room357',6,'517s'),
		   ('Room358',2,'518s'),
		   ('Room359',2,'519s'),
		   ('Room360',2,'520s'),

		   ('Room361',3,'501e'),
		   ('Room362',3,'502e'),
		   ('Room363',3,'503e'),
		   ('Room364',3,'504e'),
		   ('Room365',3,'505e'),
		   ('Room366',2,'506e'),
		   ('Room367',2,'507e'),
		   ('Room368',2,'508e'),
		   ('Room369',2,'509e'),
		   ('Room370',2,'510e'),
		   ('Room371',2,'511e'),
		   ('Room372',2,'512e'),
		   ('Room373',2,'513e'),
		   ('Room374',4,'514e'),
		   ('Room375',4,'515e'),
		   ('Room376',4,'516e'),
		   ('Room377',4,'517e'),
		   ('Room378',4,'518e'),
		   ('Room379',4,'519e'),
		   ('Room380',4,'520e'),
	
		   ('Room381',8,'501w'),
		   ('Room382',8,'502w'),
		   ('Room383',8,'503w'),
		   ('Room384',8,'504w'),
		   ('Room385',2,'505w'),
		   ('Room386',2,'506w'),
		   ('Room387',2,'507w'),
		   ('Room388',2,'508w'),
		   ('Room389',2,'509w'),
		   ('Room390',3,'510w'),
		   ('Room391',3,'511w'),
		   ('Room392',3,'512w'),
		   ('Room393',3,'513w'),
		   ('Room394',4,'514w'),
		   ('Room395',4,'515w'),
		   ('Room396',4,'516w'),
		   ('Room397',4,'517w'),
		   ('Room398',5,'518w'),
		   ('Room399',5,'519w'),
		   ('Room400',4,'520w'),

           ('Elevator1',0,'100'),
		   ('Elevator2',0,'200'),
		   ('Elevator3',0,'300'),
		   ('Elevator4',0,'400'),
		   ('Elevator5',0,'500'),

		   ('Corridor1',0,'1n'),
		   ('Corridor2',0,'1s'),
		   ('Corridor3',0,'1e'),
		   ('Corridor4',0,'1w'),
		   ('Corridor5',0,'2n'),
		   ('Corridor6',0,'2s'),
		   ('Corridor7',0,'2e'),
		   ('Corridor8',0,'2w'),
		   ('Corridor9',0,'3n'),
		   ('Corridor10',0,'3s'),
		   ('Corridor11',0,'3e'),
		   ('Corridor12',0,'3w'),
		   ('Corridor13',0,'4n'),
		   ('Corridor14',0,'4s'),
		   ('Corridor15',0,'4e'),
		   ('Corridor16',0,'4w'),
		   ('Corridor17',0,'5n'),
		   ('Corridor18',0,'5s'),
		   ('Corridor19',0,'5e'),
		   ('Corridor20',0,'5w'),

		   --('Reception',0,'000'),

		   ('Bar1',0, '001'),
		   ('Bar2',0,'002'),
		   ('Bar3',0,'003'),
		   ('Bar4',0,'004'),
		   ('Bar5',0,'005'),
		   ('Bar6',0,'006'),

		   ('Restaurant1',0,'008'),
		   ('Restaurant2',0,'009'),
		   ('Restaurant3',0,'010'),
		   ('Restaurant4',0,'011'),
		   
		   ('Meeting Room1',0,'012'),
		   ('Meeting Room2',0,'013'),
		   ('Meeting Room3',0,'014'),
		   ('Meeting Room4',0,'015'),
		   ('Meeting Room5',0,'016'),
		   ('Meeting Room6',0,'017'),
		   ('Meeting Room7',0,'018'),
		   ('Meeting Room8',0,'019'),
		   ('Meeting Room9',0,'020'),
		   ('Meeting Room10',0,'021'),

		   ('Gym1',0,'022'),
		   ('Gym2',0,'023'),
		   ('Gym3',0,'024'),
		   ('Gym4',0,'025'),

		   ('Sauna1',0,'026'),
		   ('Sauna2',0,'027'),
		   ('Sauna3',0,'028'),
		   ('Sauna4',0,'029'),
		   ('Sauna5',0,'030'),
		   ('Sauna6',0,'031'),
		   ('Sauna7',0,'032'),
		   ('Sauna8',0,'033'),
		   ('Sauna9',0,'034'),
		   ('Sauna10',0,'035'),

		   ('Hair Salon',0,'036')
GO
