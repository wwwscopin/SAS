** ‘Special’ class domain: DM **;
PROC CDISC MODEL=SDTM;
SDTM       SDTMVERSION= "3.1";
DOMAINDATA DATA=WORK.DM
           DOMAIN=DM
           CATEGORY=SPECIAL;
RUN;


** ‘Events’ class domain: AE **;
PROC CDISC MODEL=SDTM;
SDTM       SDTMVERSION= "3.1";
DOMAINDATA DATA=WORK.AE
           DOMAIN=AE
           CATEGORY=EVENTS;
RUN;


** ‘Interventions’ class domain: CM **;
PROC CDISC MODEL=SDTM;
SDTM       SDTMVERSION= "3.1";
DOMAINDATA DATA=WORK.CM
           DOMAIN=CM
           CATEGORY=INTERVENTIONS;
RUN;


** ‘Findings’ class domain: IE **;
PROC CDISC MODEL=SDTM;
SDTM       SDTMVERSION= "3.1";
DOMAINDATA DATA=WORK.IE
           DOMAIN=IE
           CATEGORY=FINDINGS;
RUN;
