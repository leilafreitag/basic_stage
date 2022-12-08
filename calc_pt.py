import sys, argparse, os
import numpy as np

#takes list of momenta and angles and returns a list of transverse momenta corresponding to the momentum-angle pair in each index.

def parse_arguments(argv=None):

        parser = argparse.ArgumentParser()

        # List of input root files
        parser.add_argument("-wantMom","--wantMom", help="Write yes if want to return pt", required=False)
       	parser.add_argument("-wantEta","--wantEta", help="Write	yes if want to return eta", required=False) 
        parser.add_argument("-p", "--momentum", help="Input momentum", nargs="*", type=int, required=False)
        parser.add_argument("-theta", "--theta", help="Input angle theta", nargs="*",type=float, required=True)
        return parser.parse_args(argv)


def calc_eta(theta):
    #theta=int(theta)
    theta=theta*np.pi/180 #convert the angle to radians
    eta=-np.log(np.tan(theta/2))
    return(eta)

def calc_pt(p,theta):
    #p=int(p)
    eta=calc_eta(theta)
    p_t = p/np.cosh(eta)
    return p_t


if __name__ == "__main__":

    # Argument parsing
    args = parse_arguments(sys.argv[1:])

    if args.wantMom=="yes":
         print([calc_pt(p,theta) for (p,theta) in zip(args.momentum,args.theta)])
    if args.wantEta=="yes":
         print([calc_eta(theta) for theta in args.theta])


