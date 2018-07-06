Readme.md
==========

Das Projekt "Stock Price Oracle" diente dem Erlernen von Docker und Smart Contracts. Es bietet die Möglichkeit aktuelle Aktienpreise aus dem Web ([https://iextrading.com/developer/](https://iextrading.com/developer/)) abzurufen und in einen Ethereum Smart Contract zu schreiben, damit andere Smart Contracts diese von dort vollautomatisiert abrufen und weiternutzen können. Da von Smart Contracts aus kein direkter Zugriff auf Web-APIs möglich ist, sondern nur auf bestehende Blockchain-Daten zurückgegriffen werden kann, ist dies ein wertvoller Dienst und notwendiger Zwischenschritt.

Das Projekt ist konfiguriert für die Erstellung und Nutzung einer privaten Ethereum Blockchain.


Docker Run
----------

Um Image herunterzuladen und von der Bash zu starten:

```bash
docker run -it ronnyy/stockpriceoracle:start-bash
```

von hier sind folgende Befehle für tests naheliegend:

```bash
# einmaliger Abruf API und Update Smart Contract
./03_SPO-Usage/01b_update-contract.sh
# das gleiche, aber als Dauerschleife
./03_SPO-Usage/01_update-contract-regularly.sh
```
	
Um keine weiteren Befehle eingeben zu müssen und direkt in die Dauerschleife "Aktienpreise abrufen und auf die Blockchain posten" zu starten:
	
```bash
docker run -it ronnyy/stockpriceoracle:start-loop
```

Docker Build
-------------
Link Git: [https://github.com/ronnykersten/stockpriceoracle](https://github.com/ronnykersten/stockpriceoracle)

Auf dem Git stehen die für den eigenen Build nötigen Dateien bereit. Abruf durch:

```bash
mkdir "StockPriceOracle"
cd "StockPriceOracle"
git clone https://github.com/ronnykersten/stockpriceoracle
```

Jetzt kann direkt der Build erfolgen:
```bash
docker build -t stockpriceoracle:start-bash .
```



