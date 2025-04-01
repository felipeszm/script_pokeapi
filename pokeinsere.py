import psycopg2
import requests
import sys

###--FUNÇÃO DE OBTER DADOS--##
#
#recebe id do pokemon e retorna as informações do Pokemon + especie + evolução + triggers de evol
def getDadosPokemon(pokemon_id, nMoves):
    #req para pokemon -> coletamos a maioria dos dados aqui
    url=f'https://pokeapi.co/api/v2/pokemon/{pokemon_id}'
    responsePoke= requests.get(url)
    dados_temp= responsePoke.json()

    dadosPokemon={
        'id': dados_temp['id'],
        'name': dados_temp['name'],
        'height': dados_temp['height'],
        'weight': dados_temp['weight'],
        'urlEspecie': dados_temp['species']['url'],
        'types': [
            {'type_name': tip['type']['name'],
                'slot': tip['slot'],
                'url': tip['type']['url']}
            for tip in dados_temp['types']
        ],
        'moves': [
            {
                'name': mov['move']['name'],
                'url': mov['move']['url']
            } #                                <------ cada pokemón tem em torno de 90 moves aprendíveis
            for mov in dados_temp['moves'][:nMoves]#<----- limitei a 5 por pokemón por questões de performance =) 
        ],
        'abilities': [
            {
                'name': ab['ability']['name'],
                'url': ab['ability']['url']}
            for ab in dados_temp['abilities']
        ]
    }
    #req para espécie, shape e geração
    responseSpecies = requests.get(dadosPokemon['urlEspecie'])
    dadosSpecies =responseSpecies.json()

    responseShape = requests.get(dadosSpecies['shape']['url'])
    dadosShape =responseShape.json()

    responseGeneration = requests.get(dadosSpecies['generation']['url'])
    dadosGeneration =responseGeneration.json()

    #req para evolucao-> fazemos uma req na url do dicionario evoluchain 
    #obtemos dados dela para devolvermos e facilitar o uso
    urlEvoluchain=dadosSpecies['evolution_chain']['url']
    responseEvoluchain=requests.get(urlEvoluchain)
    dadosEvoluchain = responseEvoluchain.json()
    evolinfo=dadosEvoluchain['chain']
    evoldetails={}

    #organizando dados de evolução e checando se existe url trigger
    for evolucao in evolinfo.get('evolves_to', []):
        evoldetails=evolucao.get('evolution_details', [{}])[0]
        urlEvolTrigger=evoldetails.get('trigger', {}).get('url')
        trigger_id=None
        trigger_name=None
        if urlEvolTrigger:
            responseTrigger = requests.get(urlEvolTrigger)
            dadosTrigger= responseTrigger.json()
            trigger_id= dadosTrigger.get('id', None)
            trigger_name=dadosTrigger.get('name',None)
        
        #tratando casos de nulidade
        dadosEvolucao ={
            'id':dadosEvoluchain['id'],
            'min_level':evoldetails.get('min_level', None),
            'min_affection':evoldetails.get('min_affection', None),
            'min_beauty':evoldetails.get('min_beauty', None),
            'min_happiness':evoldetails.get('min_happiness', None),
            'gender':evoldetails.get('gender', None),
            'time_of_day':evoldetails.get('time_of_day', None),
            'needs_overworld_rain':evoldetails.get('needs_overworld_rain', False),
            'relative_physical_stats':evoldetails.get('relative_physical_stats', None),
            'turn_upside_down':evoldetails.get('turn_upside_down', False),
            'trigger_id':trigger_id,
            'trigger_name':trigger_name
        }

    #retornando dados essenciais de pokemon
    return {
        'id':dadosPokemon['id'],
        'name':dadosPokemon['name'],
        'height':dadosPokemon['height'],
        'weight':dadosPokemon['weight'],
        'species_id':dadosSpecies['id'],
        'species_name':dadosSpecies['name'],
        'is_baby':dadosSpecies['is_baby'],
        'is_mythical':dadosSpecies['is_mythical'],
        'is_legendary':dadosSpecies['is_legendary'],
        'evolution_data':dadosEvolucao,
        'trigger_name':trigger_name,
        'types':dadosPokemon['types'],
        'moves':dadosPokemon['moves'],
        'abilities': dadosPokemon['abilities'],
        'shape': dadosShape,
        'generation': dadosGeneration
    }

#FUNÇÃO DE INSERIR TIPOS
#
#insere tipos e relaciona com o Pokémon
def insereTipos(cursor, pokemon_id, tipos):
    #para cada tipo do pokemon (q pegamos de dadosPokemon)
    for tipo in (tipos):
        type_url= tipo['url']
        
        #req em cada tipo
        responseTipo=requests.get(type_url)
        dadosTipo=responseTipo.json()
        type_id=dadosTipo['id']
        
        #insere tipo
        cursor.execute("""INSERT INTO public.type (id, name)
            VALUES (%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (type_id, tipo['type_name']))
        
        #relação de pokemon com tipo
        cursor.execute("""INSERT INTO public.type_pokemon (id_pokemon_fk, id_type_fk, slot)
            VALUES (%s,%s,%s)
            ON CONFLICT (id_pokemon_fk, id_type_fk) DO NOTHING;""", (pokemon_id, type_id, tipo['slot']))
        

#FUNÇÃO DE INSERIR EVOLUÇÃO
#
#recebe o cursor para realizar o insert, dados da evolução e id da espécie
def insereEvolucao(cursor, evolution_data, species_id):
    trigger_id = evolution_data['trigger_id']
    trigger_name = evolution_data['trigger_name']
    if trigger_id and trigger_name:
        insereTrigger(cursor, trigger_id, trigger_name, species_id)
    
    #insert em evoluchain
    cursor.execute("""INSERT INTO public.evolution_chain (
            id, min_affection, min_beauty, min_happiness, min_level, gender, time_of_day,
            needs_overworld_rain, relative_physical_stats, turn_upside_down, id_species_fk, id_evolution_trigger_fk
        ) VALUES (%s,%s,%s,%s, %s,%s, %s,%s,%s,%s,%s,%s)
        ON CONFLICT (id) DO NOTHING;""", (
        evolution_data['id'],
        evolution_data['min_affection'],
        evolution_data['min_beauty'],
        evolution_data['min_happiness'],
        evolution_data['min_level'],
        evolution_data['gender'],
        evolution_data['time_of_day'],
        evolution_data['needs_overworld_rain'],
        evolution_data['relative_physical_stats'],
        evolution_data['turn_upside_down'],
        species_id,
        trigger_id
    ))

#FUNÇÃO INSERE TRIGGER
#
#obtem: cursor p/ query no BD, id, nome da trigger e id de espécie
#realiza: insere a trigger fornecida na tabela evolution_trigger
#essa função é usada apenas pela função insereEvolucao
def insereTrigger(cursor, trigger_id, trigger_name, species_id):
    cursor.execute("""INSERT INTO public.evolution_trigger (id, name, id_species_fk)
        VALUES (%s,%s,%s)
        ON CONFLICT (id) DO NOTHING;""", (trigger_id, trigger_name, species_id))

#FUNÇÃO INSERE ABILITIES
#
#recebe cursor e dados do pokemón e realiza insert na tabela ability e de relação
def insereAbilities(cursor, dadosPokemon):
    for ability in (dadosPokemon['abilities']):
        ability_name= ability['name']
        ability_url= ability['url']
        
        #req para CADA ability
        response = requests.get(ability_url)
        dadosAbility = response.json()
        ability_id = dadosAbility['id']
        #insert na table ability
        cursor.execute("""INSERT INTO public.ability (id, name)
            VALUES (%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (ability_id, ability_name))
        #tabela de relação pokemon com ability
        cursor.execute("""INSERT INTO public.ability_pokemon (id_pokemon_fk, id_ability_fk)
            VALUES (%s, %s)
            ON CONFLICT (id_pokemon_fk, id_ability_fk) DO NOTHING;""", (dadosPokemon['id'], ability_id))

#FUNCAO INSERE MOVES
#
#recebe o cursor, moves e id do pokemon -> realiza inserção em moves e suas relações
def insereMoves(cursor, moves, pokeid, types):
    for move in moves:
        move_name=move['name']
        move_url=move['url']
        move_type_name=move['name']
        
        #req para moves
        response=requests.get(move_url)
        dadosMove=response.json()
        
        #dados de moves e tabelas relacionadas
        id= dadosMove.get('id', None)
        accuracy= dadosMove.get('accuracy', None)
        effect_chance= dadosMove.get('effect_chance', None)
        pp=dadosMove.get('pp', None)
        power=dadosMove.get('power', None)
        priority=dadosMove.get('priority', None)
        #req para tabela damage_class
        damage_class=dadosMove.get('damage_class', {})
        damage_class_url=damage_class.get('url')
        response_damage_class=requests.get(damage_class_url)
        dadosDamage_class=response_damage_class.json()
        #separando dados de damage_class    
        damage_class_id=dadosDamage_class.get('id')
        damage_class_name=dadosDamage_class.get('name')
        #pegando url de category e ailment do dicionário meta
        meta = dadosMove.get('meta', {})
        category = meta.get('category', {})
        category_url = category.get('url')
        ailment =meta.get('ailment', {})
        ailment_url=ailment.get('url')
        #
        #TARGET
        target=dadosMove.get('target', {})
        target_url=target.get('url')
        responsetarget=requests.get(target_url)
        dadosTarget=responsetarget.json()
        #dados de target    
        target_id=dadosTarget.get('id')
        target_name=dadosTarget.get('name')
        #
        #
        #contest_type
        contest_type=dadosMove.get('contest_type', {})
        contest_type_url=contest_type.get('url')
        responsecontest_type=requests.get(contest_type_url)
        dadosContest_type=responsecontest_type.json()
        #contest_type
        contest_type_id=dadosContest_type.get('id')
        contest_type_name=dadosContest_type.get('name')
        #
        #
        response_category=requests.get(category_url)#<=== req de categoria
        dadosCategory=response_category.json()
        category_id=dadosCategory.get('id')
        category_name=dadosCategory.get('name')

        response_ailment=requests.get(ailment_url)#<=== req de ailment
        dadosAilment=response_ailment.json()
        ailment_id=dadosAilment.get('id')
        ailment_name=dadosAilment.get('name')

        #insert na tabela ailments
        cursor.execute("""INSERT INTO public.move_ailment (id, name)
            VALUES (%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (ailment_id, ailment_name))
        #na tabela move_damage_classes
        cursor.execute("""INSERT INTO public.move_damage_classes (id, name)
            VALUES (%s, %s)
            ON CONFLICT (id) DO NOTHING;""", (damage_class_id, damage_class_name))
        #move_contest_type
        cursor.execute("""INSERT INTO public.contest_type (id, name)
            VALUES (%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (contest_type_id, contest_type_name))
        
        #insere os dados na tabela 'moves' e suas tabelas relacionadas
        #a ordem deve primeiro moves para poder referenciar posteriormente no restante das tabelas
        cursor.execute("""INSERT INTO public.moves (id, name, accuracy, effect_chance, pp, power, priority, id_contest_type_fk)
            VALUES (%s, %s, %s, %s, %s, %s,%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (id, move_name, accuracy, effect_chance, pp, power, priority, contest_type_id))
        #pokemon_moves
        cursor.execute("""INSERT INTO public.pokemon_moves (id_moves_fk, id_pokemon_fk)
            VALUES (%s,%s)
            ON CONFLICT (id_moves_fk, id_pokemon_fk) DO NOTHING;""", (id, pokeid))
        #move_category
        cursor.execute("""INSERT INTO public.move_category (id, name, id_moves_fk)
            VALUES (%s,%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (category_id, category_name, id))
        #moves_move_ailment
        cursor.execute("""INSERT INTO public.moves_move_ailment (id_moves_fk, id_move_ailment_fk)
            VALUES (%s, %s)
            ON CONFLICT (id_moves_fk, id_move_ailment_fk) DO NOTHING;""", (id, ailment_id))
        #moves_move_damage
        cursor.execute("""INSERT INTO public.moves_move_damage (id_moves_fk, id_move_damage_fk)
            VALUES (%s,%s)
            ON CONFLICT (id_moves_fk, id_move_damage_fk) DO NOTHING;""", (id, damage_class_id))
        #move_target
        cursor.execute("""INSERT INTO public.move_target (id, name)
            VALUES (%s,%s)
            ON CONFLICT (id) DO NOTHING;""", (target_id, target_name))
        #moves_move_target
        cursor.execute("""INSERT INTO public.moves_move_target (id_moves_fk, id_move_target_fk)
            VALUES (%s,%s)
            ON CONFLICT (id_moves_fk, id_move_target_fk) DO NOTHING;""", (id, target_id))



#FUNÇÃO DE INSERIR ESPECIE
#
#recebe cursor e dados da espécie e insere na tabela species
def insereEspecie(cursor, species_id, species_name, is_baby, is_mythical, is_legendary, dadosShape, dadosGeneration):
    idShape = dadosShape['id']
    nameShape = dadosShape['name']
    cursor.execute("""INSERT INTO public.shape (id, name)
        VALUES (%s, %s)
        ON CONFLICT (id) DO NOTHING;
    """, (idShape, nameShape))
    idGeneration = dadosGeneration['id']
    nameGeneration = dadosGeneration['name']
    cursor.execute("""INSERT INTO public.generation (id, name)
        VALUES (%s, %s)
        ON CONFLICT (id) DO NOTHING;
    """, (idGeneration, nameGeneration))
    cursor.execute("""INSERT INTO public.species (id, name, is_baby, is_mythical, is_legendary, id_shape_fk, id_generation_fk)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        ON CONFLICT (id) DO NOTHING;
    """, (species_id, species_name, is_baby, is_mythical, is_legendary, idShape, idGeneration))

#FUNÇÃO DE INSERIR DADOS DO POKEMON
#
#->recebe cursor e dados do pokemon
def insereDadosPokemon(cursor, dadosPokemon):
    insereEspecie(cursor, dadosPokemon['species_id'],
                  dadosPokemon['species_name'],
                  dadosPokemon['is_baby'],
                  dadosPokemon['is_mythical'],
                  dadosPokemon['is_legendary'], dadosPokemon['shape'], dadosPokemon['generation'])
    insereEvolucao(cursor, dadosPokemon['evolution_data'], dadosPokemon['species_id'])
    
    cursor.execute("""INSERT INTO public.pokemon (id, name, height, weight, id_species_fk)
        VALUES (%s, %s, %s, %s, %s)
        ON CONFLICT (id) DO NOTHING;
    """, (dadosPokemon['id'], dadosPokemon['name'], dadosPokemon['height'], dadosPokemon['weight'], dadosPokemon['species_id']))
    #implementamos o insert de tipos, depois moves e finalmente abilities
    insereTipos(cursor, dadosPokemon['id'], dadosPokemon['types'])
    insereMoves(cursor, dadosPokemon['moves'], dadosPokemon['id'], dadosPokemon['types'])
    insereAbilities(cursor, dadosPokemon)
    #fim da função. 
    #aqui, nesse ponto todos os dados para o pokemon o qual a id foi fornecida foram inseridos nas tabelas

    
def main():
    #conectando ao servidor
    conex =psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='minhasenha',
        host='localhost',
        port='5433'
    )
    #colocando um cursor (o canal por onde faremos as querys) na conexão com o BD
    cursor = conex.cursor()
    print(f'\nAlgoritmo de inserção de Pokemóns')
    print(f'\nInforme a quantidade de Pokemóns a serem consumidos da API: ')
    n = int(input())
    print(f'\nInforme a quantidade de movimentos por Pokemón a serem consumidos da API')
    print(f'\nPS: por questões de performance, recomendamos um número < 5: ')
    nMoves = int(input())
    for i in range(24,24+ (n+1)):
        dadosPokemon = getDadosPokemon(i, nMoves)
        insereDadosPokemon(cursor, dadosPokemon)
        prog=((i-24)/n)*100
        #****feedback de progresso no terminal****
        print(f"\rProgresso: {prog:.0f}%", end="")
        sys.stdout.flush()
    print(f"\n")
    conex.commit()
    cursor.close()
    conex.close()

main()
