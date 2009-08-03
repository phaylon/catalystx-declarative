use MooseX::Declare;
use MooseX::AttributeHelpers;

role CatalystX::Declare::Controller::Meta::TypeConstraintMapping {

    use MooseX::Types::Moose qw( HashRef Object );

    use aliased 'Moose::Meta::TypeConstraint';
    use aliased 'MooseX::Method::Signatures::Meta::Method', 'MethodWithSignature';

    has method_type_constraint_map => (
        metaclass   => 'Collection::Hash',
        is          => 'ro',
        isa         => HashRef[Object],
        required    => 1,
        lazy_build  => 1,
        provides    => {
            get         => 'get_method_type_constraint',
            set         => 'set_method_type_constraint',
        },
    );

    method _build_method_type_constraint_map {
        return +{};
    }

    around add_method ($method_name, $method) {

        if (is_Object $method and $method->isa(MethodWithSignature)) {

            my $tc = $method->type_constraint;

            $self->set_method_type_constraint(
                $method_name,
                $tc,
            );
        }

        return $self->$orig($method_name, $method);
    }

    method find_method_type_constraint (Str $name) {

        my @parents =
            grep { $_->can('get_method_type_constraint') }
            map  { $_->meta }
            grep { $_->can('meta') }
                 $self->linearized_isa;

        for my $isa ($self, @parents) {
            
            if (my $tc = $isa->get_method_type_constraint($name)) {
                return $tc;
            }
        }

        return undef;
    }
}

