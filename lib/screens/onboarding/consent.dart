
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_app/bloc/onboarding_bloc.dart';

/// Second intro screen
///
/// This Widget represents the first of the intro
/// screens, his purpose is to display a welcome
/// message to the user and explain the app.
class ConsentScreen extends StatelessWidget {
  /// Index of the screen
  final int screenIndex;
  bool checkedValue = false;

  ConsentScreen(this.screenIndex);

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      condition: (_, current) => current is NeedToValidateState && current.index == screenIndex,
      // This page is always valid
      listener: (context, _) => context.bloc<OnBoardingBloc>().add(ValidationSuccessEvent()),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          reverse: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 64),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Termini e Condizioni e Informativa sulla Privacy di Balance',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Finalità e Modalità del Trattamento',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(

                      'Il trattamento dei Suoi dati personali attraverso l\'applicazione Balance '
                  'è effettuato per la realizzazione delle finalità '
                      'scientifiche del Progetto "Smartphone-based Postural Stability Monitoring System for Falls Prevention in the Elderly". '
                    'Il Progetto è stato redatto conformemente agli standard metodologici '
                    'del settore disciplinare interessato ed è depositato presso il Dipartimento '
                    'di Scienze Pure e Applicate dell’Università degli Studi di Urbino Carlo Bo, ove verrà conservato per cinque anni dalla '
                    'conclusione programmata della ricerca stessa. I suoi dati personali saranno '
                    'trattati soltanto nella misura in cui siano indispensabili in relazione all\'obiettivo '
                'del progetto, nel rispetto di quanto previsto dalla normativa vigente in materia di '
                    'protezione dei dati personali e conformemente alle disposizioni di cui alle '
                    'autorizzazioni generali dell\’Autorità Garante per la protezione dei dati personali.'
                    'I Suoi dati saranno trattati esclusivamente dal Titolare, dal Responsabile '
                    'scientifico e/o da soggetti autorizzati nell’ambito della realizzazione del Progetto, '
                    'con strumenti automatizzati e non, esclusivamente per consentire lo svolgimento della '
                    'ricerca in parola e di tutte le relative operazioni ed attività connesse, comprese quelle '
                    'amministrative, condotte dal’Università di Urbino in collaborazione con Digit srl. I dati '
                    'saranno trattati mediante strumenti elettronici adottando la pseudonimizzazione: l’identità '
                    'dell’utente non verrà mai richiesta ma ad ogni installazione verrà associato un identificativo '
                    'univoco che consentirà di correlare nel tempo i dati forniti dallo stesso utente. Inoltre, '
                    'sebbene la sperimentazione non ricada nei dispositivi di tipo medico, l’utilizzo di Balance '
                    'costituirà un servizio per i soggetti utilizzatori attraverso un monitoraggio personale dei propri progressi.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Base Giuridica del Trattamento',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                      'Il trattamento dei Suoi dati personali viene effettuato dal Titolare nell’ambito di esecuzione dei propri compiti di '
                      'interesse pubblico ai sensi dell’art. 6, comma 1, lett. e) del GDPR.'
                      'Il trattamento delle categorie particolari di dati personali (dati sensibili) viene effettuato per '
                      'fini di ricerca scientifica ai sensi dell’art. 9, comma 2, lett. j) del GDPR e sulla base di un consenso '
                      'esplicito da Lei prestato (art. 9, comma 2, lett. a) del GDPR; art. 110 del Codice Privacy.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Periodo di Conservazione dei Dati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                      'I dati raccolti nel corso del progetto saranno registrati, elaborati e conservati fino al raggiungimento delle finalità '
                      'del Progetto per 5 anni, come richiesto dalle riviste di pubblicazione del lavoro. I dati verranno conservati '
                      'sotto la responsabilità del Prof. Alessandro Bogliolo',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Natura del conferimento dei dati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                      'Il conferimento dei suoi dati per le suddette finalità di ricerca è indispensabile per lo svolgimento del Progetto e non '
                      'discende da un obbligo normativo e/o contrattuale. Il mancato conferimento determina l’impossibilità di partecipare al Progetto.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Destinatari dei dati ed eventuale trasferimento all’estero',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'I suoi dati personali potranno essere comunicati in forma anonima e/o aggregata a fini di pubblicazione scientifica del lavoro '
                  'a riviste presso cui si farà la sottomissione del lavoro. I dati verranno raccolti, gestiti ed elaborati interamente '
                  'dall’Università di Urbino e Digit Srl.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Divulgazione dei risultati della ricerca',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                      'I dati saranno diffusi solo in forma rigorosamente anonima e/o aggregata e comunque secondo modalità che non La rendano identificabile'
                      '(ad esempio attraverso pubblicazioni scientifiche, statistiche e convegni scientifici e/o la creazione di banche dati, '
                      'anche con modalità ad accesso aperto).',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Diritti dell’interessato',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                      'Nella sua qualità di Interessato e partecipante al progetto, ha il diritto in qualunque momento di ottenere la conferma '
                      'dell’esistenza o meno dei medesimi dati e di conoscerne il contenuto e l’origine, gode altresì dei diritti di cui alla sezione 2, '
                      '3 e 4 del capo III del GDPR (es. chiedere al titolare del trattamento: l\'accesso ai dati personali e la rettifica o la cancellazione '
                      'degli stessi; la limitazione del trattamento che lo riguardano; di opporsi al loro trattamento, oltre al diritto alla portabilità dei dati).'
                      'L’interessato ha diritto a chiedere al titolare, ai sensi degli artt. 15, 16, 17, 18, 19, 20 e 21 del GDPR, l’accesso ai propri dati personali '
                      'e la rettifica o la cancellazione degli stessi o la limitazione del trattamento che lo riguardano o di opporsi al loro trattamento, '
                      'oltre al diritto alla portabilità dei dati. La cancellazione non è consentita per i dati contenuti negli atti che devono '
                      'obbligatoriamente essere conservati dall’Università; Inoltre ha diritto a revocare il consenso in qualsiasi momento, '
                      'senza pregiudicare la liceità del trattamento basata sul consenso prestato prima della revoca; Ai sensi dell’art. 17, comma 3, lett. d) '
                      'del GDPR, il diritto alla cancellazione non sussiste per i dati il cui trattamento sia necessario ai fini di ricerca '
                      'scientifica qualora rischi di rendere impossibile e/o pregiudicare gravemente gli obiettivi della ricerca stessa.'
                      'proporre reclamo a un’autorità di controllo.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Informativa sulla Raccolta Dati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'L\'applicazione ha lo scopo di valutare la sua postura attraverso '
                  'il suo smartphone. I suoi dati sono al sicuro e utilizzati dai ricercatori'
                  'per migliorare l\'applicazione e contribuire alla comunità scientifica.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '1. Dati Collezionati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Raccogliamo e archiviamo tutte le informazioni personali '
                  'relative alla sua persona solo se decide di fornircele volontariamente, '
                  'al momento della registrazione o attraverso l\'uso continuato dell\'App.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '2. Come sono collezionati i dati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Raccogliamo i suoi dati personali in due momenti. La prima volta'
                  'che apri Balance e quando la utilizza per i test. Inoltre, i dati relativi alla sua postura '
                  'saranno collegati ai suoi dati personali ma potranno essere ricostruiti solo dal personale ammesso.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '3. Come saranno utilizzati i dati',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'I dati raccolti vengono utilizzati per scopi di ricerca e per fornire un '
                  'migliore esperienza per l\'utente finale.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '4. Politica di ritiro del consenso e cancellazione',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Nel caso in cui dovesse cambiare idea, può chiedere la cancellazione dei dati '
                  'nella pagina delle impostazioni di Balance. Dopodiché, rimuovere semplicemente l\'applicazione.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Continuando, Dichiaro',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'di aver letto e compreso i Termini e Condizioni e l\'Informativa sulla Privacy '
                      'per l\'utilizzo dell\'app Balance. Di aver compreso che l\'utilizzo di Balance è del tutto volontario '
                      'e che ci si potrà ritirare dal progetto in qualsiasi momento, senza '
                      'dover dare spiegazioni. Di aver compreso la natura e le attività dell\'applicazione '
                      'e che la partecipazione a questo progetto non comporterà il diritto ad alcun riconoscimento di alcun '
                      'vantaggio di natura economica diretto o indiretto.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('di aver letto e compreso i Termini e Condizioni e l\'Informativa sulla Privacy '
                                ' e quindi di acconsentire al trattamento dei propri dati personali e sensibili '
                                'eventualmente raccolti nell’ambito dell\'utilizzo di Balance per finalità di '
                                'ricerca medica, biomedica, psicologica, pedagogica e sociale',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text("di essere d'accordo su Termini, Condizioni e Informativa sulla Privacy di Balance"),
              ),
              SizedBox(height: 128)
            ],
          ),
        ),
      ),
    );
  }
}