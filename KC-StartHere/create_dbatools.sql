USE [master]
GO

/****** Object:  Database [dbatools]    Script Date: 4/23/2024 11:59:29 AM ******/
CREATE DATABASE [dbatools]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbatools', FILENAME = N'E:\Data\dbatools.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbatools_log', FILENAME = N'E:\Data\dbatools_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbatools].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [dbatools] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [dbatools] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [dbatools] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [dbatools] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [dbatools] SET ARITHABORT OFF 
GO

ALTER DATABASE [dbatools] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [dbatools] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [dbatools] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [dbatools] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [dbatools] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [dbatools] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [dbatools] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [dbatools] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [dbatools] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [dbatools] SET  DISABLE_BROKER 
GO

ALTER DATABASE [dbatools] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [dbatools] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [dbatools] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [dbatools] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [dbatools] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [dbatools] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [dbatools] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [dbatools] SET RECOVERY FULL 
GO

ALTER DATABASE [dbatools] SET  MULTI_USER 
GO

ALTER DATABASE [dbatools] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [dbatools] SET DB_CHAINING OFF 
GO

ALTER DATABASE [dbatools] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [dbatools] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [dbatools] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [dbatools] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [dbatools] SET QUERY_STORE = OFF
GO

ALTER DATABASE [dbatools] SET  READ_WRITE 
GO

