--WINDOWS ACCOUNTS
SELECT N'CREATE LOGIN ['+sp.[name]+'] FROM WINDOWS;'
FROM master.sys.server_principals AS sp
WHERE sp.[type] IN ('U', 'G') AND
      sp.is_disabled=0 AND
      sp.[name] NOT LIKE 'NT [AS]%\%';
--SQL ACCOUNTS
--RUN ON PRIMARY THEN EXECUTE THE RESULTS ON SECONDARY 
SELECT N'CREATE LOGIN [' + sp.[name] + '] WITH PASSWORD=0x' + CONVERT(NVARCHAR(MAX), l.password_hash, 2)
       + N' HASHED, CHECK_POLICY=OFF, ' + N'SID=0x' + CONVERT(NVARCHAR(MAX), sp.[sid], 2) + N';'
FROM master.sys.server_principals AS sp
    INNER JOIN master.sys.sql_logins AS l
        ON sp.[sid] = l.[sid]
WHERE sp.[type] = 'S'
      AND sp.is_disabled = 0;
 
 
CREATE LOGIN [IEHP\_sqladmins] FROM WINDOWS;
CREATE LOGIN [IEHP\SQLHSP1SVC] FROM WINDOWS;
CREATE LOGIN [IEHP\solaradmin] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1Execute] FROM WINDOWS;
CREATE LOGIN [IEHP\svcExBackups] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1Admins] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1DBOwner] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1DataWriter] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1BackupOperator] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1DataReader] FROM WINDOWS;
CREATE LOGIN [IEHP\_HSPAdmins] FROM WINDOWS;
CREATE LOGIN [IEHP\SQLMEDPSSRSSVC] FROM WINDOWS;
CREATE LOGIN [IEHP\PJAMSVC] FROM WINDOWS;
CREATE LOGIN [IEHP\HSP1SuppDataReader] FROM WINDOWS;
CREATE LOGIN [IEHP\QSQLLITSVC] FROM WINDOWS;
CREATE LOGIN [IEHP\sqladmin9] FROM WINDOWS;
CREATE LOGIN [HSP1S1A\HSP] FROM WINDOWS;
CREATE LOGIN [IEHP\PSQLAGENTSVC] FROM WINDOWS;
CREATE LOGIN [IEHP\v2805] FROM WINDOWS;

CREATE LOGIN [HSP_dbo] WITH PASSWORD=0x02005C4A5114B43AFB8371B6E4CFE7C25DD1A6AED8791E1BAC6405F8978D155646DB21795612172EEED7CF79ACC59DAE2F42C4A61301E478D334D1FC43DF0DD22EE73D561B2B HASHED, CHECK_POLICY=OFF, SID=0x6A980E4896B42042B50A174CD928A140;
CREATE LOGIN [HSPLicensing_sa] WITH PASSWORD=0x0200B2B2A6F8C8C7A87ED8CDC08ADA01F1EEEE01C70BCC4D1FE53716678FCCE17DE988F19F4971984CB506F03247CA5DE09EBFC7F053C805B836D855237642D3A83FA6EBBB73 HASHED, CHECK_POLICY=OFF, SID=0xD341D75F2D205B45B22591A64A0EB257;
CREATE LOGIN [SQLiConnectUser] WITH PASSWORD=0x0200007E9AF790DF4F9A0B5561973F21945397D0FC4997C166C02E40075D1D13294BAEEC7128D10C19EAEE8C702CF9B5DFA761E47B4D643022C10633E3C6B461E4C61CB634A4 HASHED, CHECK_POLICY=OFF, SID=0xA634231D06D8AF42A5F9209FA9DEF1F7;
CREATE LOGIN [SQLEDIMSUser01] WITH PASSWORD=0x0200CC814F1940098E4916DF99C99DB3FF6692C627831AE53F790A0FC6B7C955FBEEF01E23A87E080B421065A7A80D160B0B81E424A5D9CDEB561DC624390119A8988E93B063 HASHED, CHECK_POLICY=OFF, SID=0x1148F767751C9A439678E01CAD369259;
CREATE LOGIN [SQLBatchLoadUser01] WITH PASSWORD=0x0200F0D89E876B38F84CA0179883659A6E96584FA6205FB9B3915944EC58FE9EBD7D68F300B45344E5B01DEBB250CBF71FB9834DBBE152B64CA2F920C18A59A445E8572F9810 HASHED, CHECK_POLICY=OFF, SID=0xC224272E906A2245852B794AF9D6005E;
CREATE LOGIN [SQLiConnectUser01] WITH PASSWORD=0x02008DB7A5E9B492100F54DE706D22F617B7258FE7F25A28545CCBA4DDD97678F51DC6E41E4965EC7E9F1C3AE8818E4C082B170F4552FDC13C20CC5ACDD525F5CA706FED37A5 HASHED, CHECK_POLICY=OFF, SID=0x5ED93CF0F66BC64B8C304E2374BC631F;
CREATE LOGIN [SQLSSISUser01] WITH PASSWORD=0x0200D8FA1A7584029002B0B8CFCA2AE44E905117F392E654F13EAF2346C18FBB253902C800C6056FD9C0EED5D13BEF082B24236AB116F6C5EAE1F8988B2EFAE78A55D1D65ECF HASHED, CHECK_POLICY=OFF, SID=0xC4CA7919696EF64EB5EC14FE4E748FAD;
CREATE LOGIN [EbmUser] WITH PASSWORD=0x0200155F7C2C0FB90FD39950307670713623422E225A0FF6AB93CB6C87462F98D6D5603DC652A2E40B417452C29846C121C85854F8581404E860567BC3409B07CE59CAEC53D5 HASHED, CHECK_POLICY=OFF, SID=0xA14D3670B05747458EF591A862B83C54;
CREATE LOGIN [SQLLSRead01] WITH PASSWORD=0x0200C25136C34D357B7209F3D2076C381094B0BF9F9DB47B627843F8C988C64A6ECB617C196805DB3AF285E29FD76D675BAC83BBD64F1813299C2C337742AFBAEC59FFE83E1B HASHED, CHECK_POLICY=OFF, SID=0x0ABE75140F28D74C863E0D838B08A718;
CREATE LOGIN [SQLLSReadFIN01] WITH PASSWORD=0x0200863FC5947E995031256235776A8E03E41F66800F4606405925ADB08AB3466F6D765A8430BB93E01A9582865CD0406C33A942568FB76871A0DC2C588332E57855DF8EE0A1 HASHED, CHECK_POLICY=OFF, SID=0x0EF7E8107310E4418624EBCF73A6CBB5;