const jokes = [
	'Deine Mutter arbeitet bei Nordsee als Geruch.',
	'Deine Mutter krümelt beim Trinken.',
	'Deine Mutter läuft bei Super Mario nach links.',
	'Deine Mutter isst Kürbisjoghurt mit ganzen Früchten.',
	'Deine Mutter bekommt bei Fressnapf an der Kasse ein Leckerli.',
	'Deine Mutter kippt beim Joghurt die große in die kleine Ecke.',
	'Für deine Mutter ist Bratensoße ein Erfrischungsgetränk.',
	'Deine Mutter bringt Zwiebeln zum Heulen.',
	'Deine Mudda ist so haarig, wenn sie mit ihrem Hund spazieren geht, wird sie zuerst gestreichelt.',
	'Deine Mutter macht Passbilder auf Google Earth.',
	'Deine Mutter denkt USB ist das Nachbarland von USA.',
	'Bei deiner Mutter liegt ein Gästebuch - neben dem Bett.',
	'Deine Mutter arbeitet bei IKEA als unterste Schublade.',
	'Deine Mutter lispelt beim Chatten.',
	'Deine Mutter arbeitet bei der Losbude als Niete.',
	'Deine Mutter hat Gürtelgröße Äquator.',
	'Deine Mutter schreckt mit ihrem Gesicht die Eier ab.',
	'Deine Mutter dreht die Quadrate bei Tetris.',
	'Deine Mutter bellt, wenn es an der Tür klingelt.',
	'Deine Mutter sammelt Laub für den Blätterteig.',
]

exports.handler = async function (event, context) {
	const response = {
		'joke': jokes[Math.floor(Math.random() * jokes.length)]
	}
	
	const json = JSON.stringify(response)
	
	return {
		statusCode: 200,
		headers: {
            'Access-Control-Allow-Origin': '*'
        },
		body: json,
	}
}