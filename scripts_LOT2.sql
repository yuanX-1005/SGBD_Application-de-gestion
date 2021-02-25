REM **********************************************************************
REM Script Création du Package BusinessPack
REM ********************************************************************** 

CREATE OR REPLACE PACKAGE BusinessPack IS 
	FUNCTION EFFECTIFCOMMERCIAL (IdPromotion INTEGER) RETURN NUMBER;
	PROCEDURE MAJNBANNONCEUR(IdPromotion NUMBER, NbC NUMBER);
	PROCEDURE PROMOTIONANNONCE;
	PROCEDURE CREATIONANNONCE (IdPromotion INTEGER, IdC INTEGER);
	PROCEDURE LISTECOM (IdOf INTEGER);
	PROCEDURE LISTECOMPROMO (IdPromotion INTEGER);
END BusinessPack; 
/

CREATE OR REPLACE PACKAGE BODY BusinessPack IS

-----------------------------------------
		--EFFECTIF COMMERCIAL--
-----------------------------------------

FUNCTION EFFECTIFCOMMERCIAL (IdPromotion INTEGER) RETURN NUMBER IS 

NbIdCom numeric;

BEGIN
	SELECT COUNT(Id_Com) INTO NbIdCom FROM ANNONCER where IdPromotion = Id_Prom; 
	RETURN NbIdCom; 
END EFFECTIFCOMMERCIAL;

-----------------------------------------
		--MAJ NB ANNONCEUR--
-----------------------------------------


PROCEDURE MAJNBANNONCEUR(IdPromotion NUMBER, NbC NUMBER) IS

NbEffectifCommercila numeric;

BEGIN
select EFFECTIFCOMMERCIAL(IdPromotion) into NbEffectifCommercila from dual;

    FOR tuple IN (select Id_Prom as idP, NbreAnnonceur AS NbA from PROMOTION where IdPromotion = Id_Prom) LOOP

        IF NbC >= 0 THEN 
        	tuple.NbA := tuple.NbA + NbC;
			update promotion set NbreAnnonceur = tuple.NbA where IdPromotion = Id_Prom;
        ELSE
        	IF NbC < 0 And (tuple.NbA + NbC < 0 or tuple.NbA + NbC < NbEffectifCommercila ) THEN
        		DBMS_OUTPUT.PUT_LINE('Impossible: soit le nouveau nombre d''annonceur est inferieur à 0, soit le nouveau nombre d''annonceur est inferieur au nombre d''annonceur déclaré. ');
				DBMS_OUTPUT.PUT_LINE('Le nombre d''annonceur déclaré pour la promotion ' || tuple.idP || ' est égal à ' || NbEffectifCommercila ||'.');
			ELSE 
        		tuple.NbA := tuple.NbA + NbC;
				update promotion set NbreAnnonceur = tuple.NbA where IdPromotion = Id_Prom;
        	end if;
        end if;
    end loop;
END MAJNBANNONCEUR;

-----------------------------------------
		--PROMOTION ANNONCE--
-----------------------------------------

PROCEDURE PROMOTIONANNONCE IS
BEGIN
	FOR Tuple IN (Select Id_Prom as idP, Intitule_Prom as intitule from Promotion) LOOP
		DBMS_OUTPUT.PUT_LINE(EFFECTIFCOMMERCIAL(tuple.idP)||' commercial(aux) annonce(ent) la promotion " '|| tuple.intitule || ' "');
	END LOOP;
END PROMOTIONANNONCE;


-----------------------------------------
		--CREATION ANNONCE--
-----------------------------------------

PROCEDURE CREATIONANNONCE (IdPromotion INTEGER, IdC INTEGER) IS
BEGIN
	For Tuple in (Select Id_Com from COMMERCIAL where idc = Id_Com) LOOP
		For Tuple2 in (Select Id_Prom, NbreAnnonceur from PROMOTION where IdPromotion = Id_Prom) Loop
			If EFFECTIFCOMMERCIAL(IdPromotion) < tuple2.NbreAnnonceur THEN
				insert into ANNONCER (Id_Prom,Id_Com,DateAnnonce) VALUES (IdPromotion,IdC,sysdate);
			ELSE
				DBMS_OUTPUT.PUT_LINE('Le nombre maximum d''annonceur pour la promotion ' || tuple2.Id_Prom ||' n''est pas suffisant.'); 
				DBMS_OUTPUT.PUT_LINE('Le nombre maximum d''annonceur est ' || tuple2.NbreAnnonceur);
			END IF;
		END LOOP;
	END LOOP;
END CREATIONANNONCE;

-----------------------------------------
		--LISTE COM--
-----------------------------------------

PROCEDURE LISTECOM (IdOf INTEGER) IS
BEGIN
	DBMS_OUTPUT.PUT_LINE(chr(13) || 'Le(s) nom(s) et prénom(s) des commerciaux sponsorisant l''offre ' || IdOf );
	FOR Tuple IN (Select Id_Offre, Id_Com , Accorder from Sponsoriser where Id_Offre = IdOf and Accorder ='o') LOOP
		FOR Tuple2 IN (SELECT Nom_Com as Nom, Prenom_Com as Prenom FROM Commercial where Id_Com = tuple.Id_Com) LOOP 
	    	DBMS_OUTPUT.PUT_LINE( Tuple2.Nom ||' '||Tuple2.Prenom );
    	END LOOP;
	END LOOP;
END LISTECOM;

-----------------------------------------
		--LISTE COM PROMO--
-----------------------------------------

PROCEDURE LISTECOMPROMO (IdPromotion INTEGER) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Commerciaux de l''offre de la promotion ' || IdPromotion );
	For Tuple IN (Select  Id_Offre, Id_Prom from Offre where Id_Prom = IdPromotion ) LOOP
		LISTECOM(Tuple.Id_Offre);
	END LOOP;
	
END LISTECOMPROMO;

END BusinessPack;
/



REM **********************************************************************
REM Jeu d''essaie
REM ********************************************************************** 

REM tester la fonction EFFECTIFCOMMERCIAL

-- calculer l’effectif des commerciaux de la promotion 1
select BusinessPack.EFFECTIFCOMMERCIAL(1)
from dual;
-- calculer l’effectif des commerciaux de la promotion 2
select BusinessPack.EFFECTIFCOMMERCIAL(2)
from dual;



REM *******************************************************************************************************************

REM tester la fonction MAJNBANNONCEUR

-- augementer de 2 le nombre maximum d'annonceur pour la promotion 1
select *
from promotion;

exec BusinessPack.MAJNBANNONCEUR(1,2);

select *
from promotion;

-- diminuer de 2 le nombre maximum d'annonceur pour la promotion 1
exec BusinessPack.MAJNBANNONCEUR(1,-2);

select *
from promotion;

-- diminuer de 4 le nombre maximum d'annonceur pour la promotion 1
exec BusinessPack.MAJNBANNONCEUR(1,-4); 

select *
from promotion;


REM *******************************************************************************************************************

REM tester la fonction PROMOTIONANNONCE

-- affiche à l’écran la liste des promotions et son nombre de commerciaux. 
exec BusinessPack.PROMOTIONANNONCE;




REM *******************************************************************************************************************

REM tester la fonction CREATIONANNONCE

-- ajout d'un annonceur à une promotion 
select *
from annoncer;

exec BusinessPack.CREATIONANNONCE(3,2);

select *
from annoncer;

exec BusinessPack.CREATIONANNONCE(3,4);
--impossible

select *
from annoncer;




REM *******************************************************************************************************************

REM tester la fonction LISTECOM

-- afficher la liste des commerciaux sponsorisant l'offre 
exec BusinessPack.LISTECOM(1);
exec BusinessPack.LISTECOM(2);




REM *******************************************************************************************************************


REM tester la fonction LISTECOMPROMO
-- afficher, pour chaque offre de la promotion choisi la liste des commerciaux ayant donné leur accord !!!
exec BusinessPack.LISTECOMPROMO(1);
exec BusinessPack.LISTECOMPROMO(2);


