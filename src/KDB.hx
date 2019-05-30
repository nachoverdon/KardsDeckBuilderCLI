package;

import tink.Cli;
import tink.cli.Rest;
import haxe.Json;
import haxe.Http;
import sys.io.File;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import clipboard.Clipboard;

using StringTools;

typedef Card = {
	var faction: String;
	var id: Int;
	var image: String;
	var kredits: Int;
	var rarity: String;
	var text: String;
	var title: String;
	var type: String;
}


class KDB {
	static inline final BASE_URL = 'https://kardsdeck.opengamela.com/';
	static inline final VIEW_DATA = BASE_URL + 'view?data=';
	static inline final CARDS_JSON = BASE_URL + 'assets/data/cards.json';
	static var cardsJson: Array<Card>;

	static function main() {
		Cli.process(Sys.args(), new KDB()).handle(Cli.exit);
	}

	public function new() {}

	@:alias('d')
	public var debug: Bool = false;

	@:alias('f')
	public var filePath: String;

    @:alias('n')
    public var nocopy: Bool;

    @:alias('o')
    public var open: Bool;

    @:defaultCommand
    public function generateKardsDBLink(rest: Rest<String>) {
		try {
			cardsJson = Json.parse(Http.requestUrl(CARDS_JSON));
		} catch (e:Dynamic) {
			Sys.println('Error trying to fetch the card list. Please, report this issue.\n$e');
		}

		var deck: String;

		if (filePath != null) {
			deck = File.getContent(filePath);
		} else {
			deck = Clipboard.get();
		}

		if (debug) Sys.println('Deck:\n$deck');

		final json = textToJson(deck);
		final base64 = encodeJson(json);
		final url = getUrl(base64);

		Sys.println(url);

        if (!nocopy) {
			Clipboard.set(url);
			Sys.println('Copied to the clipboard.');
		}

		if (open) {
			#if (sys && windows)
			Sys.command("start", ["", url]);
			#elseif mac
			Sys.command("/usr/bin/open", [url]);
			#elseif linux
			Sys.command("/usr/bin/xdg-open", [url, "&"]);
			#end
			Sys.println('opening browser...');
		}
    }

    function textToJson(text: String): Dynamic {
		final cardRegex = ~/^(\d)x \(\dK\) (.+)$/;
		final json = {};
		final cards = text.split('\n').filter((line: String) -> {
			return cardRegex.match(line);
		});

		if (cards.length == 0) {
			Sys.println('Please, copy your deck from the game before executing.');
			Sys.exit(0);
		}

		// final deckName = array[0];
		// final majorPower = array[1].substr(12);
		// final ally = array[2].substr(6);
		// final hq = array[3].substr(4);
		for (card in cards) {
			cardRegex.match(card);
			final id = getIdFromName(cardRegex.matched(2));
			final amount = Std.parseInt(cardRegex.matched(1));
			Reflect.setField(json, '$id', amount);
		}

		return json;
    }

	function getIdFromName(name: String): Null<Int> {
		for (card in cardsJson) {
			if (card.title == name.trim()) {
				return card.id;
			}
		}

		return null;
	}

	function encodeJson(json: Dynamic): String {
		var stringified = Json.stringify(json);
		var regex = ~/[{}"]/gm;


		stringified = regex.replace(stringified, "").trim();
		final bytes = Bytes.ofString(stringified);
		final base64 = Base64.encode(bytes);
		return base64;
	}

	function getUrl(base64: String): String {
		return VIEW_DATA + base64;
	}
}
