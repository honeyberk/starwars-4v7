use basic_stats.fx as basic_stats

# Set the python path to include helper python libs
PYTHONPATH=$(echo "\$PYTHONPATH:./src")

cgraal_align_nosim: basic_stats.to_edgelists
	###
	Align the networks using the CGRAAL algorithm.
		http://bio-nets.doc.ic.ac.uk/C-GRAAL/
	Basically, a common-neighbor model.
	###
	code.sh:
		touch $PLN(empty_similarity.txt)

		echo 'converting elist -> gw'
		CGRAAL/list2leda $PLN(basic_stats,interaction_4.elist) >> $PLN(interaction_4.gw)
		CGRAAL/list2leda $PLN(basic_stats,interaction_7.elist) >> $PLN(interaction_7.gw)

		echo 'aligning networks'
		CGRAAL/CGRAAL_unix64 $PLN(interaction_4.gw) $PLN(interaction_7.gw) $PLN(empty_similarity.txt) $PLN(cgraal_ns.nums) $PLN(cgraal_ns.names) 	

cgraal_align_Rcamie: basic_stats.to_edgelists
	###
	Align the networks using the CGRAAL algorithm, without CAMIE (who wasn't in the episode 4 movie)
	###
	code.sh:
		touch $PLN(empty_similarity.txt)

		echo 'converting elist -> gw'
		grep -v "CAMIE" $PLN(basic_stats,interaction_4.elist) > $PLN(interaction_4_Rcamie.elist)
		CGRAAL/list2leda $PLN(interaction_4_Rcamie.elist) > $PLN(interaction_4_Rcamie.gw)
		CGRAAL/list2leda $PLN(basic_stats,interaction_7.elist) > $PLN(interaction_7.gw)

		echo 'aligning networks'
		CGRAAL/CGRAAL_unix64 $PLN(interaction_4_Rcamie.gw) $PLN(interaction_7.gw) $PLN(empty_similarity.txt) $PLN(cgraal_Rcamie.nums) $PLN(cgraal_Rcamie.names) 	

cgraal_align_Mreyfinn: basic_stats.to_edgelists
	###
	Align the networks when Finn and Rey are merged.	
	###
	code.py:
		import swdata

		def write_edgelist(fname,G):
			fh = open(fname,'w')
			for x,y in G.edges():
				print >>fh, '%s %s' % (x,y)

			fh.close()

		G7 = swdata.load_interaction_net(7)

		swdata.merge_nodes(G7,[['REY','FINN']])

		write_edgelist('$PLN(interaction_7_Mreyfinn.elist)',G7)

	code.sh:
		touch $PLN(empty_similarity.txt)

		echo 'converting elist -> gw'
		CGRAAL/list2leda $PLN(basic_stats,interaction_4.elist) >> $PLN(interaction_4.gw)
		CGRAAL/list2leda $PLN(interaction_7_Mreyfinn.elist) >> $PLN(interaction_7_Mreyfinn.gw)

		echo 'aligning networks'
		CGRAAL/CGRAAL_unix64 $PLN(interaction_4.gw) $PLN(interaction_7_Mreyfinn.gw) $PLN(empty_similarity.txt) $PLN(cgraal_Mreyfinn.nums) $PLN(cgraal_Mreyfinn.names) 	

cgraal_align_Mreyfinn_reyfinnEluke: cgraal_align_Mreyfinn
	###
	Align the networks when Finn and Rey are merged and made equal to Luke.
	###
	code.sh:
		echo "LUKE REY__FINN 1.0" > $PLN(reyfinnEluke_similarity.txt)

		echo 'aligning networks'
		CGRAAL/CGRAAL_unix64 $PLN(interaction_4.gw) $PLN(interaction_7_Mreyfinn.gw) $PLN(reyfinnEluke_similarity.txt) $PLN(cgraal_Mreyfinn_reyfinnEluke.nums) $PLN(cgraal_Mreyfinn_reyfinnEluke.names)
