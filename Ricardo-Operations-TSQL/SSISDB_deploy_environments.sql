-- How to use it
-- exec catalog.deploy_environment 11



USE SSISDB;
GO

-- USE AT OWN RISK! This stored procedure was created on the SSISDB on SQL Server version:
--      Microsoft SQL Server 2012 (SP1) - 11.0.3128.0 (X64) 
--      Dec 28 2012 20:23:12 
--      Copyright (c) Microsoft Corporation
--      Developer Edition (64-bit) on Windows NT 6.1 &lt;x64&gt; (Build 7601: Service Pack 1)


-- Drop any previous versions of this stored procedure
IF OBJECT_ID ( 'catalog.deploy_environment', 'P' ) IS NOT NULL 
    DROP PROCEDURE catalog.deploy_environment;
GO

-- project_id is the identifier in the properties of a project
CREATE PROCEDURE catalog.deploy_environment
    @project_id bigint 
AS 

	-- Internal variables used within the cursor
	Declare @environment_name as nvarchar(128);
	Declare @project_name as nvarchar(128);
	Declare @folder_name as nvarchar(128);
	Declare @environment_folder_name as nvarchar(128);
	Declare @reference_type as char(1);
	Declare @folder_id as bigint;
	Declare @environment_description as nvarchar(1024);
	Declare @environment_id as bigint;


	DECLARE ref_environment_cursor CURSOR FOR 
		-- Loop through all in the project referenced Environments
		SELECT		r.environment_name
		,			p.name as project_name
		,			ISNULL(r.environment_folder_name, f.name) as folder_name
		,			ISNULL(r.environment_folder_name, f.name) as environment_folder_name	-- for @reference_type = A
		,			r.reference_type as reference_type
		,			f.folder_id
		,			e.description as environment_description
		,			e.environment_id
		FROM		[SSISDB].[internal].environment_references as r
		INNER JOIN	[SSISDB].[internal].projects as p
					on r.project_id = p.project_id
		INNER JOIN	[SSISDB].[internal].folders as f
					on p.folder_id = f.folder_id
		INNER JOIN	[SSISDB].[internal].environments as e
					on e.folder_id = f.folder_id
					and e.environment_name = r.environment_name
		WHERE		r.project_id = @project_id

	OPEN ref_environment_cursor

	FETCH NEXT FROM ref_environment_cursor 
	INTO @environment_name, @project_name, @folder_name, @environment_folder_name, @reference_type, @folder_id, @environment_description, @environment_id;

	Print '-- Create scripts for deploying enviroments'
	Print '-- Project ID: ' + CAST(@project_id as varchar(5)) + ' - Project name: ' + @project_name
	Print ''

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Create environment
		Print '-- Create environment: ' + @environment_name
		Print 'EXEC		[SSISDB].[catalog].[create_environment]'
		Print '			@environment_name=N''' + @environment_name + ''''
		Print ',			@environment_description=N''' + @environment_description + ''''
		Print ',			@folder_name=N''' + @folder_name + ''''
		Print 'GO'
		Print ''

		-- Create reference from environment to project. Relative or Absolute
		Print '-- Reference environment ' + @environment_name + ' to project ' + @project_name
		IF @reference_type = 'R'
		BEGIN
			-- Reference Relative
			Print 'Declare @reference_id bigint'
			Print 'EXEC		[SSISDB].[catalog].[create_environment_reference]'
			Print '			@environment_name=N''' + @environment_name + ''''
			Print ',			@reference_id=@reference_id OUTPUT'
			Print ',			@project_name=N''' + @project_name + ''''
			Print ',			@folder_name=N''' + @folder_name + ''''
			Print ',			@reference_type=R'
			Print 'GO'
			Print ''
		END
		ELSE
		BEGIN
			-- Reference Absolute
			Print 'Declare @reference_id bigint'
			Print 'EXEC		[SSISDB].[catalog].[create_environment_reference]'
			Print '				@environment_name=N''' + @environment_name + ''''
			Print ',			@environment_folder_name=N''' + @environment_folder_name + ''''
			Print ',			@reference_id=@reference_id OUTPUT'
			Print ',			@project_name=N''' + @project_name + ''''
			Print ',			@folder_name=N''' + @folder_name + ''''
			Print ',			@reference_type=A'
			Print 'GO'
			Print ''
		END

		
		-- Internal variables used within the cursor	
		Declare @environment_value as sql_variant--nvarchar(max); -- SQL_VARIANT
		Declare @variable_name as nvarchar(128);
		Declare @sensitive as bit;
		Declare @variable_description as nvarchar(1024);
		Declare @variable_type as nvarchar(128);

		DECLARE environment_var_cursor CURSOR FOR 
			-- Loop through all in the variables of the active environment
			SELECT		CAST(ev.value as varchar(255)) as environment_value
			,			ev.name as variable_name
			,			ev.sensitive
			,			ev.description as variable_description
			,			ev.type as variable_type
			FROM		[SSISDB].[catalog].environment_variables as ev
			WHERE		environment_id = @environment_id

		OPEN environment_var_cursor

		FETCH NEXT FROM environment_var_cursor 
		INTO @environment_value, @variable_name, @sensitive, @variable_description, @variable_type;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Environments variables
			Print '-- Create variables for environment: ' + @environment_name + ' - ' + @variable_name

			-- Variable declaration depending on the type within the environment
			IF @variable_type = 'Boolean'
			BEGIN
				Print 'DECLARE @var bit = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Byte'
			BEGIN
				Print 'DECLARE @var tinyint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'DateTime'
			BEGIN
				Print 'DECLARE @var datetime = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Decimal'
			BEGIN
				Print 'DECLARE @var decimal(38,18) = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Double'
			BEGIN
				Print 'DECLARE @var float = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Int16'
			BEGIN
				Print 'DECLARE @var smallint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Int32'
			BEGIN
				Print 'DECLARE @var int = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Int64'
			BEGIN
				Print 'DECLARE @var bigint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'SByte'
			BEGIN
				Print 'DECLARE @var smallint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'Single'
			BEGIN
				Print 'DECLARE @var float = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'String'
			BEGIN
				Print 'DECLARE @var sql_variant = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'UInt32'
			BEGIN
				Print 'DECLARE @var bigint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END
			ELSE IF @variable_type = 'UInt64'
			BEGIN
				Print 'DECLARE @var bigint = N''' + ISNULL(CAST(@environment_value as nvarchar(max)),'*S*E*N*S*I*T*I*V*E*') + ''''
			END

			Print 'EXEC		[SSISDB].[catalog].[create_environment_variable]'
			Print '			@variable_name=N''' + @variable_name + ''''
			IF @sensitive = 0
			BEGIN
				Print ',			@sensitive=False'
			END
			ELSE
			BEGIN
				Print ',			@sensitive=True'
			END
				Print ',			@description=N''' + @variable_description +  ''''
			Print ',			@environment_name=N''' + @environment_name + ''''
			Print ',			@folder_name=N''' + @folder_name + ''''
			Print ',			@value=@var'
			Print ',			@data_type=N''' + @variable_type + ''''
			Print 'GO'
			Print ''

			FETCH NEXT FROM environment_var_cursor 
			INTO @environment_value, @variable_name, @sensitive, @variable_description, @variable_type;
		END
		CLOSE environment_var_cursor;
		DEALLOCATE environment_var_cursor;
		-- End Environments variables

		-- Parameter - Variable mapping
		Declare @object_type as smallint
		Declare @parameter_name as nvarchar(128);
		Declare @object_name as nvarchar(260);
		Declare @folder_name2 as nvarchar(128);
		Declare @project_name2 as nvarchar(128);
		Declare @value_type as char(1)
		Declare @parameter_value as nvarchar(128);

		DECLARE parameter_var_cursor CURSOR FOR 
			-- Loop through variables referenced to a parameter
			SELECT		op.object_type
			,			parameter_name
			,			[object_name]
			,			f.name as folder_name
			,			p.name as project_name
			,			value_type
			,			referenced_variable_name as parameter_value
			FROM		[SSISDB].[internal].object_parameters as op
			INNER JOIN	[SSISDB].[internal].projects as p
						on p.project_id = op.project_id
			INNER JOIN	[SSISDB].[internal].folders as f
						on p.folder_id = f.folder_id
			WHERE		op.project_id = @project_id
			AND			referenced_variable_name is not null

		OPEN parameter_var_cursor

		FETCH NEXT FROM parameter_var_cursor 
		INTO @object_type, @parameter_name, @object_name, @folder_name2, @project_name2, @value_type, @parameter_value;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Reference variables
			Print '-- Reference variable ' + @parameter_value + ' to parameter ' + @parameter_name
			Print 'EXEC		[SSISDB].[catalog].[set_object_parameter_value]' 
			Print '			@object_type=' + CAST(@object_type as varchar(5))
			Print ',			@parameter_name=N''' + @parameter_name + ''''
			Print ',			@object_name=N''' + @object_name + ''''
			Print ',			@folder_name=N''' + @folder_name2 + '''' ----
			Print ',			@project_name=N''' + @project_name2 +  '''' ---
			Print ',			@value_type=' + @value_type
			Print ',			@parameter_value=N''' + @parameter_value + ''''
			Print 'GO'
			Print ''

			FETCH NEXT FROM parameter_var_cursor 
			INTO @object_type, @parameter_name, @object_name, @folder_name2, @project_name2, @value_type, @parameter_value;
		END
		CLOSE parameter_var_cursor;
		DEALLOCATE parameter_var_cursor;
		-- End Parameter - Variable mapping

		FETCH NEXT FROM ref_environment_cursor 
		INTO @environment_name, @project_name, @folder_name, @environment_folder_name, @reference_type, @folder_id, @environment_description, @environment_id;
	END
	CLOSE ref_environment_cursor;
	DEALLOCATE ref_environment_cursor;
GO
/****** DISCLAIMER ******
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/